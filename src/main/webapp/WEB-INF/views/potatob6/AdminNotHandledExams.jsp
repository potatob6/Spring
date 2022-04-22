<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!--引入标签库-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <script src="${pageContext.request.contextPath}/static/potatob6/js/axios.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/potatob6/js/jquery-3.6.0.min.js"></script>
    <title>审核</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            font-size: 1.1rem;
        }

        body {
            position: relative;
            width: 100vw;
            height: 100vh;
            background: url("${pageContext.request.contextPath}/static/potatob6/svg/AdminPage_bg.svg") center center no-repeat;
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-content: center;
        }

        #selfCenter {
            margin: 50px;
            left: 50px;
            top: 50px;
            width: 400px;
            bottom: 50px;
            backdrop-filter: blur(2rem);
            -webkit-backdrop-filter: blur(2rem);
            box-shadow: 0 0 18px rgba(70,70,70,0.2);
            border: 1px solid #dbe2ef;
            border-radius: 10px;
            flex-shrink: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        #items {
            width: 100%;
            margin: 50px;
            margin-left: 0;
            min-width: 700px;
            flex-shrink: 1;
            backdrop-filter: blur(1.5rem);
            -webkit-backdrop-filter: blur(1.5rem);
            border: 1px solid #dbe2ef;
            border-radius: 10px;
            box-shadow: 0 0 18px rgba(70,70,70,0.2);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .item {
            width: 100%;
            height: 200px;
            backdrop-filter: blur(2rem);
            -webkit-backdrop-filter: blur(2rem);
            border: 1px solid #dbe2ef;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            box-shadow: 0 0 30px rgba(70,70,70,0.2);
            border-radius: 10px;
            transition: all 0.3s;
            flex-shrink: 0;
        }

        .item:hover {
            box-shadow: 0 0 10px rgba(70,70,70,0.2);
            backdrop-filter: blur(0.3rem);
            -webkit-backdrop-filter: blur(0.3rem);
            cursor: pointer;
            transform: scale(1.03);
        }

        img {
            width: auto;
            height: 50%;
        }

        p {
            flex-shrink: 0;
        }

        .corner {
            border-radius: 30px;
            height: 30px;
            width: 30px;
            background-color: #f73859;
            position: absolute;
            right: 0;
            top: 0;
            transform: translate(15px, -15px);
            color: white;
            text-align: center;
            line-height: 30px;
            justify-content: center;
            align-items: center;
        }

        #avatar {
            width: 100px;
            height: 100px;
            border-radius: 50px;
        }

        hr {
            width: 60%;
            height: 4px;
            background-color: rgba(70,70,70,0.3);
            border-radius: 2px;
            border: none;
            margin: 40px 0;
        }

        p {
            margin: 20px 0;
        }

        img:hover {
            cursor: pointer;
        }

        #items_top {
            margin: 20px 0;
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            flex-shrink: 0;
        }

        tr, tbody {
            width: 100%;
        }

        td, th {
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            padding: 20px;
        }

        button {
            width: 80px;
            height: 40px;
            border-radius: 7px;
            background-color: #17b978;
            outline: none;
            border: none;
            transition: all 0.3s;
            color: white;
            font-size: small;
        }

        button:hover {
            cursor: pointer;
        }

        .accept:hover {
            background-color: #086972;
        }

        .reject {
            background-color: #fa4659;
        }

        .reject:hover {
            background-color: #b80d57;
        }

        #page_bar {
            width: 100%;
            height: 50px;
            position: absolute;
            bottom: 0;
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-items: center;
            flex-shrink: 0;
        }

        .opera {
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-items: center;
        }

        .opera > button {
            margin: 0 2px;
        }

        .lists {
            flex-shrink: 1;
            overflow-y: scroll;
        }
    </style>
</head>

<body>
    <div id="selfCenter">
        <img width="100" id="avatar" height="100" src="${pageContext.request.contextPath}/${admin.avatarPath}" />
        <hr>
        <p>欢迎，${admin.adminName}</p>
        <p>管理员编号:${admin.adminId}</p>
        <p>图书管理后台系统</p>
        <hr>
    </div>
    <div id="items">
        <div id="items_top">
            <div style="width: 20px; flex-shrink: 0"></div>
            <img onclick="window.location.href=${pageContext.request.contextPath}/Admin/" style="width: 22px; height: 22px; flex-shrink: 0" src="${pageContext.request.contextPath}/static/potatob6/svg/return.svg" />
            <p style="flex-shrink: 1; margin: 0;margin-left: 20px;width: 100%;text-align: center">待处理审核</p>
            <div style="width: 20px; flex-shrink: 0"></div>
        </div>

        <div class="lists" style="width: 100%;">
            <table>
                <tbody id="tbody1">
                    <tr>
                        <th>审核序号</th>
                        <th>类型</th>
                        <th>申请的用户</th>
                        <th>创建时间</th>
                        <th>延期时间</th>
                        <th>处理状态</th>
                        <th>附加信息</th>
                        <th>操作</th>
                    </tr>

                    <c:forEach var="item" items="${list}">
                        <tr>
                            <td>${item.examId} </td>
                            <td>${item.examType} </td>
                            <td>${item.examUser.userName} </td>
                            <td>${item.examCreateTime} </td>
                            <c:if test="${item.examType.equals(\"申请延期\")}">
                                <td>${item.examExtra1} 天</td>
                            </c:if>
                            <c:if test="${!item.examType.equals(\"申请延期\")}">
                                <td></td>
                            </c:if>
                            <td>${item.examHandleStatus} </td>
                            <td>${item.examComment} </td>
                            <td class="opera">
                                <button class="reject" onclick="reject(${item.examId})">拒绝</button>
                                <button class="accept" onclick="accept(${item.examId})">同意</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div id="page_bar">
            <img src="${pageContext.request.contextPath}/static/potatob6/svg/loadmore.svg" onclick="loadPage()" style="width: 30px; height: 30px" />
        </div>
    </div>

    <script lang="JavaScript">
        var page = ${page}
        function loadPage() {
            axios({
                url: '${pageContext.request.contextPath}/admin/exams/pageNotHandled',
                method: 'POST',
                data: {
                    page: page + 1
                }
            }).then(response=>{
                console.log(response)
                const json = JSON.parse(response.data)
                if(json.status === 'success') {
                    console.log(json)
                    if(json.list.length !== 0) {
                        for(let i = 0; i < json.list.length; i++) {
                            let l = json.list[i]
                            console.log(l.examComment)
                            let varNew = $("<tr></tr>")
                            varNew.append($("<td>"+l.examId+"</td>"))
                            varNew.append($("<td>"+l.examType+"</td>"))
                            varNew.append($("<td>"+l.examUser.userName+"</td>"))
                            varNew.append($("<td>"+l.examCreateTime+"</td>"))
                            if (l.examType === '申请延期') {
                                varNew.append($("<td>" + l.examExtra1 + "天</td>"))
                            } else {
                                varNew.append($("<td></td>"))
                            }
                            varNew.append($("<td>"+l.examHandleStatus+"</td>"))

                            if (l.examComment !== undefined) {
                                varNew.append($("<td>"+l.examComment+"</td>"))
                            } else {
                                varNew.append($("<td></td>"))
                            }
                            let n1 = $("<td class=\"opera\"></td>")
                            n1.append($("<button class=\"reject\" onclick=\"reject("+l.examId+")\">拒绝</button>"))
                            n1.append($("<button class=\"accept\" onclick=\"accept("+l.examId+")\">同意</button>"))
                            varNew.append(n1)

                            $("#tbody1").append(varNew)
                        }

                        page ++;
                    }
                }
            })
        }
    </script>

    <script lang="JavaScript">
        // 同意
        function accept(n) {
            axios({
                url: '${pageContext.request.contextPath}/admin/exams/accept',
                method: 'GET',
                data: {
                    "Id": n
                }
            }).then(response => {

            }).throw(error => {
                alert("错误:"+error)
            })
        }

        // 拒绝
        function reject(n) {
            axios({
                url: '${pageContext.request.contextPath}/admin/exams/reject',
                method: 'GET',
                data: {
                    "Id": n
                }
            }).then(response => {

            }).throw(error => {
                alert("错误:"+error)
            })
        }
    </script>
</body>
</html>