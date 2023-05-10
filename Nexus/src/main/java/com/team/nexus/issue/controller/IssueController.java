package com.team.nexus.issue.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.team.nexus.issue.model.service.IssueService;
import com.team.nexus.issue.model.vo.GitIssue;
import com.team.nexus.issue.model.vo.Label;
import com.team.nexus.member.model.vo.Member;
import com.team.nexus.repository.model.service.RepositoryService;

@Controller
public class IssueController {

	@Autowired
	private IssueService iService;

	@RequestMapping(value = "issueShow.mini", produces = "application/json; charset=utf-8")
	public String issueList(HttpSession session, Member m, Model model, @RequestParam(required = false) String state,
			@RequestParam(required = false) String assign) throws IOException {

		String repository = (String) session.getAttribute("repository");

		List<Label> lList = iService.getLabels(repository, session);

		String token = ((Member) (session.getAttribute("loginUser"))).getToken();

		List<GitIssue> list = iService.getIssues(repository, token, state, assign);

		model.addAttribute("list", list);
		model.addAttribute("lList", lList);
		
		
	

		return "issue/issueList";
	}

	
	
	
	@RequestMapping("issueEnroll.mini")
	public String issueEnrollForm(HttpSession session, Model model,@RequestParam(required = false) String state,
			@RequestParam(required = false) String assign) throws IOException, IOException {

		String repository = (String) session.getAttribute("repository");
		List<Label> lList = iService.getLabels(repository, session);
		
	

		
		
		model.addAttribute("lList", lList);

		return "issue/issueEnrollView";
	}

	
	
	
	@RequestMapping(value = "createIssue.mi", produces = "application/json; charset=utf-8")
	public String insertIssue(@RequestParam String title, @RequestParam(required = false) String body,
	        @RequestParam(required = false) String assignees, HttpSession session, Model model) {

	    String token = ((Member) session.getAttribute("loginUser")).getToken();
	    String repository = (String) session.getAttribute("repository");
	    String apiUrl = "https://api.github.com/repos/" + repository + "/issues";

	    JSONObject issueJson = new JSONObject();
	    issueJson.put("title", title);
	    issueJson.put("body", body);
	    JSONArray assigneesArray = new JSONArray();
	    // ### 라벨만 있으면 에러나서 주석처리함
	    // assigneesArray.add(assignees);
	    // issueJson.put("assignees", assigneesArray);

	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", "Bearer " + token);
	    headers.setContentType(MediaType.APPLICATION_JSON);
	    HttpEntity<String> requestEntity = new HttpEntity<String>(issueJson.toString(), headers);

	    RestTemplate restTemplate = new RestTemplate();
	    ResponseEntity<String> responseEntity = restTemplate.exchange(apiUrl, HttpMethod.POST, requestEntity,
	            String.class);
	    HttpStatus responseStatus = responseEntity.getStatusCode();

	    if (responseStatus != HttpStatus.CREATED) {
	        throw new RuntimeException("Failed to create issue on GitHub API: " + responseStatus.toString());
	    }
	    
	 
	    
	    Gson gson = new GsonBuilder().setLenient().create();
	    JsonObject issue = gson.fromJson(responseEntity.getBody(), JsonObject.class);
	    String issueTitle = issue.get("title").getAsString();
	    JsonObject userObject = issue.getAsJsonObject("user");
	    String authorName = userObject.get("login").getAsString();

	    model.addAttribute("authorName", authorName);
	    model.addAttribute("issueTitle", issueTitle);
	    model.addAttribute("userObject", userObject);
		  
		  
	    session.setAttribute("updateBellIcon", "updateBellIcon");

	    return "redirect:issueShow.mini";
	}


	
	
	@RequestMapping("removeRingSession")
	public String removeRingSession(HttpServletRequest request, HttpSession session) {
		
	    if (session != null ) {
	    	 session.removeAttribute("updateBellIcon");
	    }
	    return "redirect:/";
	}

	
	


	@RequestMapping(value = "issueDetail.mini", produces = "application/json; charset=utf-8")
	public String selectIssue(@RequestParam String ino, HttpSession session, Model model) {
		try {
			String token = ((Member) session.getAttribute("loginUser")).getToken();

			String repository = (String) session.getAttribute("repository");

			List<Label> lList = iService.getLabels(repository, session);

			String apiUrl = "https://api.github.com/repos/" + repository + "/issues/" + ino;

			RestTemplate restTemplate = new RestTemplate();
			HttpHeaders headers = new HttpHeaders();
			headers.set("Authorization", "Bearer " + token);
			headers.setContentType(MediaType.APPLICATION_JSON);
			HttpEntity<String> requestEntity = new HttpEntity<>("", headers);
			ResponseEntity<String> responseEntity = restTemplate.exchange(apiUrl, HttpMethod.GET, requestEntity, String.class);
			HttpStatus responseStatus = responseEntity.getStatusCode();

			if (responseStatus != HttpStatus.OK) {
				throw new RuntimeException("Failed to retrieve issue data from GitHub API: " + responseStatus.toString());
			}

			Gson gson = new GsonBuilder().setLenient().create();
			JsonObject issueJson = gson.fromJson(responseEntity.getBody(), JsonObject.class);
			String title = issueJson.get("title").getAsString();

			// body branch processing null date
			JsonElement bodyElement = issueJson.get("body");
			String body = (bodyElement != null && !bodyElement.isJsonNull()) ? bodyElement.getAsString() : null;

			String state = issueJson.get("state").getAsString();

			// Retrieve assignees array
			JsonArray assigneesArray = issueJson.getAsJsonArray("assignees");

			ArrayList<Member> list = new ArrayList<Member>();

			if (assigneesArray != null) {
				for (JsonElement assigneeElement : assigneesArray) {
					JsonObject assigneeObject = assigneeElement.getAsJsonObject();

					String userName = assigneeObject.get("login").getAsString();
					String assigneeProfiles = assigneeObject.get("avatar_url").getAsString();

					Member m = new Member();

					m.setUserName(userName);
					m.setProfile(assigneeProfiles);

					list.add(m);

					// String assigneeLogin = assigneeObject.get("login").getAsString();
					// assignees.add(assigneeLogin);
					// assigneeProfiles.add(assigneeObject.get("avatar_url").getAsString());
				}

				// System.out.println(list);
			}

			// Retrieve labels array
			JsonArray labelsArray = issueJson.getAsJsonArray("labels");
			List<String> labels = new ArrayList<>();
			if (labelsArray != null) {
				for (JsonElement labelElement : labelsArray) {
					JsonObject labelObject = labelElement.getAsJsonObject();
					String labelName = labelObject.get("name").getAsString();
					labels.add(labelName);
				}
			}

			// Retrieve issue manager's profile
			JsonObject userObject = issueJson.getAsJsonObject("user");
			String issueManagerName = userObject.get("login").getAsString();
			// String assigneeProfiles = userObject.get("avatar_url").getAsString();

			model.addAttribute("title", title);
			model.addAttribute("body", body);
			model.addAttribute("state", state);
			model.addAttribute("ino", ino);
			// model.addAttribute("assignees", assignees);
			model.addAttribute("labels", labels);
			model.addAttribute("issueManagerName", issueManagerName);
			model.addAttribute("lList", lList);
			// model.addAttribute("assigneeProfiles", assigneeProfiles);

			
			return "issue/issueDetail";
		} catch (Exception e) {
			e.printStackTrace();
			return "common/error500";
		}
	}

	
	
	
	@RequestMapping(value = "issueState.mi", produces = "application/json; charset=utf-8")
	public String updateStateIssue(@RequestParam int ino, @RequestParam String state, HttpSession session) {

		String token = ((Member) session.getAttribute("loginUser")).getToken();
		String repository = (String) session.getAttribute("repository");

		String apiUrl = "https://api.github.com/repos/" + repository + "/issues/" + ino;

		// code for changing issue status
		JsonObject json = new JsonObject();
		json.addProperty("state", state);
		String jsonStr = json.toString();

		HttpClient client = HttpClient.newBuilder().version(HttpClient.Version.HTTP_1_1).build();

		HttpRequest request = HttpRequest.newBuilder().uri(URI.create(apiUrl)).header("Authorization", "Bearer " + token)
				.header("Content-Type", "application/json").method("PATCH", HttpRequest.BodyPublishers.ofString(jsonStr)).build();

		try {
			HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
			System.out.println(response.body());
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
		}

		return "redirect:issueShow.mini";
	}

	
	
	
	
	@RequestMapping(value = "updateIssue.mi", produces = "application/json; charset=utf-8")
	public String updateIssue(@RequestParam String title, @RequestParam(required = false) String body,
			@RequestParam(required = false) String assignees, HttpSession session, int ino) {

		String repository = (String) session.getAttribute("repository");

		String apiUrl = repository + "/issues";

		System.out.println(apiUrl);

		String response = iService.gitPatchMethod(apiUrl, session, title, body, ino);

		  session.setAttribute("updateBellIcon", "updateBellIcon");
		
		return "redirect:issueShow.mini";
	}

	
	
	
	
	@RequestMapping(value = "myIssue", produces = "application/json; charset=utf-8")
	public String myIssueList(@RequestParam(value = "assign") String assign, HttpSession session, Model model) {
		String token = ((Member) session.getAttribute("loginUser")).getToken();
		String repository = (String) session.getAttribute("repository");

		String apiUrl = "https://api.github.com/repos/" + repository + "/issues";
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(apiUrl).queryParam("assignee", assign);

		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "Bearer " + token);
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<?> entity = new HttpEntity<>(headers);

		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity,
				String.class);

		JSONArray issueArray = new JSONArray();
		issueArray.add(response.getBody());

		model.addAttribute("issues", issueArray);

		return "issue/issueShow";
	}

}
