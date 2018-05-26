<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" import="org.concordiainternational.competition.ui.generators.*,org.concordiainternational.competition.ui.*,org.concordiainternational.competition.data.*,org.concordiainternational.competition.data.lifterSort.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<!--
/*
 * Copyright 2009-2012, Jean-François Lamy
 *
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */
 -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%  if (request.getParameter("time") == null) {
		// called directly, not from frame.  force automatic refresh.
		long current = System.currentTimeMillis();
		long expires = current + 4000;
		response.addDateHeader("Expires", expires);
		response.addDateHeader("Last-Modified", current);
		response.setHeader("Cache-Control","public");
	}
	String platform = request.getParameter("platformName");
	if (platform == null) {
		out.println("Platform parameter expected. URL must include ?platformName=X");
		return;
	}
	pageContext.setAttribute("platform", platform);

	String style = request.getParameter("style");
	if (style == null) {
		out.println("Style parameter expected. URL must include ?style=X");
		return;
	}
	pageContext.setAttribute("style", style);

	ServletContext sCtx = this.getServletContext();
	SessionData groupData = (SessionData)sCtx.getAttribute(SessionData.MASTER_KEY+platform);
	if (groupData == null) return;

	java.util.List<Lifter> lifters = groupData.getCurrentDisplayOrder();
	if (lifters == null || lifters.size() == 0) {
		out.println("</head><body></body></html>");
		out.flush();
		return;
	}
	java.util.List<Lifter> sortedLiftersSnatchRank = LifterSorter.resultsOrderCopy(lifters, LifterSorter.Ranking.SNATCH);
	java.util.List<Lifter> sortedLiftersCleanJerkRank = LifterSorter.resultsOrderCopy(lifters, LifterSorter.Ranking.CLEANJERK);
	java.util.List<Lifter> sortedLiftersTotalRank = LifterSorter.resultsOrderCopy(lifters, LifterSorter.Ranking.TOTAL);
	LifterSorter.assignCategoryRanks(sortedLiftersSnatchRank, LifterSorter.Ranking.SNATCH);
	LifterSorter.assignCategoryRanks(sortedLiftersCleanJerkRank, LifterSorter.Ranking.CLEANJERK);
	LifterSorter.assignCategoryRanks(sortedLiftersTotalRank, LifterSorter.Ranking.TOTAL);

	pageContext.setAttribute("lifters", lifters);
	pageContext.setAttribute("isMasters", Competition.isMasters());

	CompetitionSession group = groupData.getCurrentSession();
	if (group == null) {
		pageContext.removeAttribute("groupName");
		pageContext.setAttribute("useGroupName", false);
	} else {
		String groupName = group.getName();
		pageContext.setAttribute("groupName", groupName);
		pageContext.setAttribute("useGroupName", true);
		pageContext.setAttribute("liftsDone",
				TryFormatter.htmlFormatLiftsDone(groupData.getLiftsDone(),java.util.Locale.ENGLISH)
				);
	}
%>
<title>Results</title>
<link rel="stylesheet" type="text/css" href="${style}" />
</head>
<body>
<div class="title">
<c:choose>
	<c:when test='${useGroupName}'>
		<span class="title">Group ${groupName}</span>
		<span class="liftsDone">${liftsDone}</span>
	</c:when>
	<c:otherwise>
		<span class="title">Results</span>
		<span class="liftsDone">${liftsDone}</span>
	</c:otherwise>
</c:choose>
</div>
<table>
	<thead>
		<tr>
			<th class="narrow" style='text-align: center'>Start</th>
			<th>Name</th>
			<c:choose>
				<c:when test="${isMasters}">
					<th><nobr>Master</nobr></th>
				</c:when>
			</c:choose>
			<th class="cat">Cat.</th>
			<th class='weight'>BW</th>
			<th class='club'>Team</th>
			<th colspan="3">Snatch</th>
			<th class='cat'>Rank</th>
			<th colspan="3">Clean & Jerk</th>
			<th class='cat'>Rank</th>
			<th>Total</th>
			<th class="cat" style='text-align: center'>Rank</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="lifter" items="${lifters}" varStatus="loop">
			<jsp:useBean id="lifter" type="org.concordiainternational.competition.data.Lifter" />
			<tr>
				<td class='narrow' style='text-align: right'>${lifter.startNumber}&nbsp;</td>
				<c:choose>
					<c:when test="${lifter.currentLifter}">
						<td class='name current' data-fname='${lifter.firstName}' data-lname='${lifter.lastName}'><nobr><%= lifter.getLastName().toUpperCase() %>, ${lifter.firstName}</nobr></td>
					</c:when>
					<c:otherwise>
						<td class='name' data-fname='${lifter.firstName}' data-lname='${lifter.lastName}'><nobr><%= lifter.getLastName().toUpperCase() %>, ${lifter.firstName}</nobr></td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${isMasters}">
						<td class='club'><nobr>${lifter.mastersAgeGroup}</nobr></td>
					</c:when>
				</c:choose>
				<td class="cat" ><nobr>${lifter.shortCategory}</nobr></td>
				<td class='narrow'><%= WeightFormatter.formatBodyWeight(lifter.getBodyWeight()) %></td>
				<td class='club'><nobr>${lifter.club}</nobr></td>
				<!--  td class="weight">&nbsp;</td>  -->
				<c:choose>
					<c:when test="${lifter.snatchAttemptsDone == 0}">
						<c:choose>
							<c:when test="${lifter.currentLifter}">
								<td class='currentWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:when>
							<c:otherwise>
								<td class='requestedWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${lifter.snatchAttemptsDone > 0 }">
						<%= WeightFormatter.htmlFormatWeight(lifter.getSnatch1ActualLift()) %>
					</c:when>
					<c:otherwise>
						<td class='weight'></td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.snatchAttemptsDone == 1}">
						<c:choose>
							<c:when test="${lifter.currentLifter}">
								<td class='currentWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:when>
							<c:otherwise>
								<td class='requestedWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${lifter.snatchAttemptsDone > 1}">
						<%= WeightFormatter.htmlFormatWeight(lifter.getSnatch2ActualLift()) %>
					</c:when>
					<c:otherwise>
						<td class='weight'></td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.snatchAttemptsDone == 2}">
						<c:choose>
							<c:when test="${lifter.currentLifter}">
								<td class='currentWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:when>
							<c:otherwise>
								<td class='requestedWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${lifter.snatchAttemptsDone > 2}">
						<%= WeightFormatter.htmlFormatWeight(lifter.getSnatch3ActualLift()) %>
					</c:when>
					<c:otherwise>
						<td class='weight'></td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.bestSnatch > 0}">
						<td class='cat'>${lifter.snatchRank}</td>
					</c:when>
					<c:otherwise>
						<td class='cat'>&ndash;</td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.attemptsDone == 3}">
						<c:choose>
							<c:when test="${lifter.currentLifter}">
								<td class='currentWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:when>
							<c:otherwise>
								<td class='requestedWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${lifter.cleanJerkAttemptsDone > 0}">
						<%= WeightFormatter.htmlFormatWeight(lifter.getCleanJerk1ActualLift()) %>
					</c:when>
					<c:otherwise>
						<td class='requestedWeight'><%= lifter.getRequestedWeightForAttempt(4) %></td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.cleanJerkAttemptsDone == 1}">
						<c:choose>
							<c:when test="${lifter.currentLifter}">
								<td class='currentWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:when>
							<c:otherwise>
								<td class='requestedWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${lifter.cleanJerkAttemptsDone > 1}">
						<%= WeightFormatter.htmlFormatWeight(lifter.getCleanJerk2ActualLift()) %>
					</c:when>
					<c:otherwise>
						<td class='weight'></td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.cleanJerkAttemptsDone == 2}">
						<c:choose>
							<c:when test="${lifter.currentLifter}">
								<td class='currentWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:when>
							<c:otherwise>
								<td class='requestedWeight'>${lifter.nextAttemptRequestedWeight}</td>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${lifter.cleanJerkAttemptsDone > 2}">
						<%= WeightFormatter.htmlFormatWeight(lifter.getCleanJerk3ActualLift()) %>
					</c:when>
					<c:otherwise>
						<td class='weight'></td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.bestCleanJerk > 0}">
						<td class='cat'>${lifter.cleanJerkRank}</td>
					</c:when>
					<c:otherwise>
						<td class='cat'>&ndash;</td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.total > 0}">
						<td class='weight'>${lifter.total}</td>
					</c:when>
					<c:otherwise>
						<td class='weight'></td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${lifter.totalRank > 0}">
							<td class='cat'>${lifter.totalRank}</td>
					</c:when>
					<c:otherwise>
						<td class='cat'>&ndash;</td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>
	</tbody>
</table>
<script src="https://www.gstatic.com/firebasejs/4.13.0/firebase.js"></script>
<script>
if (navigator.onLine && ${lifters.size()} > 0) {

	let tbody = document.getElementsByTagName('tbody')[0];
	let trs = tbody.getElementsByTagName('tr');
	let data = [];

	for (let i = 0; i < trs.length; i++) {
		let tds = trs[i].getElementsByTagName('td');
		data.push([
			tds[0].innerText.trim(),
			tds[1].dataset.fname + ' ' + tds[1].dataset.lname.split(' ').pop(),
			tds[2].innerText,
			tds[3].innerText,
			tds[4].innerText,
			formatWeight(tds[5]),
			formatWeight(tds[6]),
			formatWeight(tds[7]),
			tds[8].innerText,
			formatWeight(tds[9]),
			formatWeight(tds[10]),
			formatWeight(tds[11]),
			tds[12].innerText,
			tds[13].innerText,
			tds[14].innerText
		]);
	}

	function formatWeight(td) {
		let weightType = td.className;
		if (weightType == 'success' || weightType == 'fail') {
			return td.innerText;
		} else if (weightType == 'requestedWeight') {
			return 'r' + td.innerText;
		} else if (weightType == 'currentWeight') {
			return 'c' + td.innerText;
		} else {
			return null;
		}
	}

	const config = {
		apiKey: "AIzaSyCyKa7eT6YNjw4ASlSOTUFddcM6qsMQqbg",
		authDomain: "wlscoreboard.firebaseapp.com",
		databaseURL: "https://wlscoreboard.firebaseio.com",
		projectId: "wlscoreboard",
		storageBucket: "",
		messagingSenderId: "336497861566"
	};
	firebase.initializeApp(config);

	let db = firebase.database();
	db.ref().child('currentgroup').set(data);
	db.ref().child('groups').child('${groupName}').set(data);

}
</script>
</body>
</html>
