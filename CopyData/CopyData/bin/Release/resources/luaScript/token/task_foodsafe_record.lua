
2020-12-28 10:58:02
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/game/answercard.htm?id=402881d97622ed0201767e799f370ba0&prizeid=88&basescope=true&cardid=hpcj2020-10&backGroupId=ed4f2e0737334907ab811b17e316d164
[method] GET
[resBody]









<!DOCTYPE html>
<html lang="zh-CN" >
<head>
 <base href="http://xinhua.mofangdata.cn:80/">
 <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
     <link rel="stylesheet" href="http://apps.bdimg.com/libs/bootstrap/3.3.0/css/bootstrap.min.css">
  <script src="http://apps.bdimg.com/libs/angular.js/1.3.9/angular.min.js"></script>
     <!--  <script src="http://cdn.bootcss.com/angular-ui-bootstrap/0.14.3/ui-bootstrap-tpls.js"></script> -->
   <script src="http://apps.bdimg.com/libs/jquery/2.1.1/jquery.min.js"></script>
   <script src="http://apps.bdimg.com/libs/bootstrap/3.3.0/js/bootstrap.min.js"></script>
   <script src="/js/angular-notify.js"></script>
      <script src="/js/moment.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

    
	
	<style>
		html body {
			width: 100%;
			height: 100%;
			padding: 0px;
			margin: 0px;
		}

		.centent {
			position: absolute;
			width: 100%;
			height: 100%;
			background: url(http://msite.mofangdata.cn/page/wx/prize/gameimages/bg.jpg);
			background-size: 100% 100%;
		}

		#lottery {
			width: 300px;
			height: auto;
			margin: 0 auto 0;
			/*background:url(/resource/img/prize/bg.png) no-repeat;background-size:cover;*/
		}

		#lottery table td {
			width: 100px;
			height: 100px;
			text-align: center;
			vertical-align: middle;
			font-size: 24px;
			color: #333;
		}

		#lottery table td a {
			width: 100px;
			height: 100px;
			display: block;
			text-decoration: none;
		}

		#lottery table td img {
			height: 100px;
		}

		#lottery table td.active {
			background-color: #ea0000;
		}

		.intro {
			background: rgba(255, 255, 255, 0.5);
			border-radius: 5px;
			width: 85%;
			margin: 15px auto;
			padding: 12px;
			color: #fff;
			font-size: 12px;
		}

		.intro h3 {
			text-align: center;
			font-size: normal;
			margin-bottom: 8px;
		}

		.show_message {
			width: 85%;
			position: absolute;
			left: 0;
			right: 0;
			z-index: 10;
			top: 30%;
			margin: auto;
			display: none;
		}

		.msgbox {
			width: 90%;
			height: 30%;
			border-radius: 10px;
			background: #fff;
			position: relative;
			margin: 5% auto;
			z-index: 1000;
		}

		.msgbox .title {
			color: #ff6633;
			border-top-left-radius: 10px;
			border-top-right-radius: 10px;
			background: #ffcc66;
			padding: 2%;

		}

		.msgbox .content {
			color: #666666;
			text-align: center;
			/*padding: 0 1rem;*/
			height: 90px;
			line-height: 90px;
		}

		.msgbox .ok {
			margin: 0 auto;

			color: #555555;
			text-decoration: none;
		}

		#playcount {
			position: absolute;
			font-size: 11px;
			color: #ef8619;
			margin-top: -15px;
			left: 50%;
			padding-left: -9px;
			margin-left: -24px;
		}

		.bottom {
			width: 95%;
			margin: 15px auto;
			text-align: center;
			font-size: 14px;
		}

		.txt {
			margin: 13px auto;
			position: absolute;
			top: 0;
			left: 0;
			bottom: 0;
			right: 0;
		}

		#mainbody {
			max-width: 600px;
		}

		.centents {
			max-width: 800px;
			margin: auto;
			left: 0px;
			top: 0px;
			right: 0px;
			bottom: 0px;
		}

		.loading {
			width: 100%;
			height: 100%;
			background: url('http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20180731loading.png') no-repeat;
			background-size: 100%;
			position: absolute;
			left: 0;
			top: 0;
		}

		.loading .bar {
			width: 200px;
			height: 6px;
			position: absolute;
			left: 50%;
			top: 55%;
			margin-left: -100px;
			border: 1px solid #82cbf9;
			vorder-radius: 3px;
		}

		.num {
			position: absolute;
			right: -40px;
			top: -7px;
			color: #299b13;
			height: 20px;
		}

		.squre {
			width: 0;
			height: 4px;
			background: #299b13;
			position: absolute;
			left: 0;
			top: 0;
		}

		.rule {
			width: 100%;
			height: 100%;
			background: url('http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20201220bg.png') no-repeat;
			background-size: 100% 100%;
			position: absolute;
			left: 0;
			top: 0;
			display: none;
		}

		.text {
			margin-left: 5%;
			margin-top: 20%;
			width: 90%;
			margin-bottom: 100px;
			animation: mymove 1s;
			opacity: 0;
		}

		@keyframes mymove {
			0% {
				transform: scale(0);
			}

			100% {
				transform: scale(1);
			}
		}

		.tools {
			width: 100%;
			height: 40px;
			text-align: center;
			position: absolute;
			left: 0;
			top: 80%;
		}
		.tools #showrule {
			color: #ffffff;
			font-weight: 700;
			position: absolute;
			top: 8px;
			margin-left: 5px;
		}

		.tools img {
			width: 120px;
			height: 39px;
		}

		.rule-text {
			width: 80%;
			margin-left: 10%;
			margin-top: 10px;
			padding: 10px 20px;
			border: 1px solid #07a4eb;
			border-radius: 10px;
			background: #fff;
			position: relative;
			text-align: justify;
			text-indent: 2em;
			display: none;
		}

		.sin {
			width: 10px;
			height: 10px;
			border-top: 1px solid #07a4eb;
			border-left: 1px solid #07a4eb;
			background: #fff;
			position: absolute;
			right: 20%;
			top: -6px;
			transform: rotate(45deg);
		}

		.cj {
			width: 100%;
			height: 100%;
			position: absolute;
			left: 0;
			top: 0;
			z-index: 500;
			background: rgba(0, 0, 0, 0.8);
			display: none;
		}

		.cj img {
			width: 100%;
			margin-top: -50px;
		}

		.prize {
			color: #fbda30;
			position: absolute;
			width: 100px;
			text-align: center;
			font-size: 26px;
			left: 50%;
			margin-left: -50px;
			top: 40%;
			font-style: normal;
			font-family: Arial;

		}

		#smcj {
			width: 100%;
			height: 100vh;
			position: absolute;
			left: 0;
			top: 0;
			z-index: 500;
			background: rgba(0, 0, 0, 0.8);
			display: none;
		}
		#smcj .dialog {
			width: 80%;
			height: 400px;
			border-radius: 12px;
			position: absolute;
			left: 0;
			top: 0;
			right: 0;
			bottom: 0;
			margin: auto;
			background-color: #fff;
			text-align: center;
		}
		#smcj .dialog .closeDialog {
			width: 32px;
			height: 32px;
			position: absolute;
			top: 10px;
			right: 10px;
			margin: 0;
		}
		#smcj .dialog img {
			margin-top: 20px;
			width: 100%;
		}
		#smcj .dialog p {
			padding: 20px 0;
			font-size: 18px;
			font-weight: 700;
		}
		#smcj .dialog button {
			width: 50%;
			height: 40px;
			border: none;
			border-radius: 25px;
			background-color: #ffa718;
			color: #fff;
			font-size: 18px;
			font-weight: 700;
		}
		.bwbzjl {
			background-color: #e80200;
		}
		.bwbzjl img {
			width: 100%;
		}
		.bwbzjl #form {
			width: 100%;
			height: 450px;
			padding: 0 35px;
		}
		.bwbzjl p {
			color: #fff;
			padding-top: 10px;
		}
		.bwbzjl input, .bwbzjl textarea {
			width: 100%;
			border-radius: 5px;
		}
		.bwbzjl button, .bwbmzj button {
			display: block;
			margin-top: 15px;
			width: 100%;
			height: 40px;
			border: none;
			border-radius: 25px;
			background-color: yellow;
			color: red;
			font-size: 18px;
			font-weight: 700;
		}
		.bwbmzj {
			height: 100vh;
			background-color: #fff6dd;
			padding: 80px;
		}
		.bwbmzj img {
			width: 100%;
		}
		.bwbmzj button {
			margin-top: 40px;
			background-color: red;
			color: #fff;
		}
	</style>

<title> 食品安全知识问答</title>
</head>

<body ng-app="myApp" ng-controller="customersCtrl">

	

	<div id="mainbody">
		<!-- 首页面 -->
		<div style="width: 100%;height:100%;" ng-show="firstpageshow">
			<div class="loading">
				<div class="bar">
					<i class="num">0</i>
					<i class="squre"></i>
				</div>
			</div>
			<div class="rule">
				<!-- 首页rule -->
				<div class="tools">
					<!-- <img id="showrule" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200820rule.png"
						style="margin-right:48px;" /> -->
					<img ng-click="showfirstpage()" id="startgame"
						src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20201220start.png" />
					<span id="showrule">活动规则></span>
					<div class="rule-text">
						<div class="sin"></div>
						食品安全知识有奖问答活动周期十个月，每月一期，为期一周，每期五题。五题答对即可抽奖。十期问题全部答对的网友，更有机会获得额外的抽奖机会哦~祝你好运！
					</div>

				</div>
			</div>
		</div>
		<!-- 失败页面，答题未通过时展示 -->
		<div class="again" style="width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000;display:none;">
			<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200319againbg.png"
				style="width:100%;height:100%;" />
			<a class="again-btn" ng-click="playagain()"
				style="width:100%;height:40px;position:absolute;left:0;bottom:20%;text-align:center;">
				<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200319againbtn.png"
					style="height:40px;" /></a>
		</div>
		<!-- 音量按钮，定位左上角 -->
		<div class="music" style="position:absolute;top:2%;right:3%;z-index:9999;">
			<img id="closeMusic" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20180117nyj-music.png" style="width:25px;" />
			<img id="openMusic" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20200114-stop.png" style="width:25px; display: none;" />
			<audio id="audio1" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20180723music.mp3"
				style="opacity:1;" autoplay="autoplay"></audio>
		</div>
		<!-- 答题页面，即第二页面（容器） -->
		<div ng-show="cardshow"
			style="width:100%; height: 100%; position:absolute; background:url(http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20201220answerbg.png) no-repeat; background-size:100% 100%;"
			class="centents">
		</div>
		<!-- 题目页面，即第二页面（内容） -->
		<div class="con" ng-show="cardshow" style="width:84%; position:absolute;left:0;right:0;top:18%;margin:0 auto;">
			<div style="margin-left:1%;font-size:1.3rem;">
				<h4 style="color:#166bbd;font-size:16px;line-height:20px;"><span ng-bind="card.name"></span></h4>
			</div>


			<div style="padding: 0">
				<ul id="answer_list" style="margin-left:-38px;">
					<li id="{{x}}" on-finish ng-repeat="x in card.questions track by $index"
						style="border:1px dashed #aaafb3;font-size:1.3rem;position:relative;border-radius:10px;margin-bottom:6px;list-style:none;width:100%;padding:0px 10px;color:#000;background:transparent;">
						<div ng-click="answerquestion(x,$index,$event)">{{index}}{{x}}</div>
						<div style="width:15px;height:15px;position:absolute;right:2px;top:20%;">
							<img class="correct" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/answer19dadui.png"
								style="width:100%;display:none;" />
							<img class="error" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/answer19dax.png"
								style="width:100%;display:none;" />
						</div>
					</li>

				</ul>
				<div class="nextq"
					style="width:94%;margin-left:3%;border-radius:10px;text-align:center;margin-top:10px;">
					<img ng-click="next()" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20201220next.png"
						style="height:30px;" />
				</div>

			</div>
			<div id="post_answer"
				style="width:94%;margin-left:3%;border-radius:10px;text-align:center;display:none;margin-top:0px;"
				ng-click="postAnswer()">
				<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20201220next.png" style="height:30px;" />
			</div>

		</div>
	</div>
	<!--抽奖页面-->
	<div class="centents ng-hide" ng-show="gameshow" style="background: url('http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200323cjbg.png'); background-size:100% 100%;position:absolute;width: 100%;height: 100%; ">
		<div id="pointer" class="pointer" style="transform-origin:49.7% 48.4%;transition: all 4s;width:100%;height:100%;position:absolute;left:0;top:0;background:url('http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200319click.png') no-repeat; background-size:100% 100%;"></div>
		<div id="play" ng-click="testClick()" style="width:15%;height:10%;position:absolute;left:42%;top:44%;"></div>
	</div>
	<!-- 中奖页面（保温杯抽奖） -->
	<div class="bwbzjl ng-hide" ng-show="zjlshow">
		<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20201220bwbzjl.png" alt="中奖了">
		<div id="form">
			<p style="color: #fff;">请提交您的个人联系方式，以便发放奖品，不提交将视为自动放弃本次抽奖。</p>
			<p>姓名</p>
			<input type="text" name="name" id="formName" placeholder="请输入您的姓名">
			<p>手机</p>
			<input type="tel" name="tel" onkeyup="value=value.replace(/[^\d]/g,'')" maxlength=11 id="formTel" placeholder="请输入您的手机号码">
			<p>收件地址</p>
			<textarea name="place" id="formPlace" placeholder="请输入您的详细收件地址"></textarea>
			<button ng-click="submitForm()">提交</button>
		</div>
	</div>
	<!-- 未中奖页面（保温杯抽奖） -->
	<div class="bwbmzj ng-hide" ng-show="mzjshow">
		<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20201220bwbmzj.png" alt="没中奖">
		<button ng-click="bgckGame()">知道了</button>
	</div>
	<!-- 具体题目 -->
	<div ng-show="answershow" style="background: none;padding-bottom:20px;">
		<div id="answers" style="display:none;" style="width:80%;">
			<ul>
				<li ng-repeat=" oldcard in oldcards">
					<div>
						<h4><span ng-bind="oldcard.name"></span></h4>
					</div>
					<div>
						正确答案：<span ng-bind="oldcard.answer"></span>
					</div>
				</li>
				</li>
			</ul>
		</div>
	</div>
	<!-- 抽奖结果 -->
	<div class="show_message">
		<div class="msgbox">
			<div class="title">抽奖结果</div>
			<div class="content"></div>
			<div style="text-align:center;width:100%;padding-bottom:5px;">
				<button class="ok btn" ng-click="okClick()" href="javascript:void(0);">确定</button>
			</div>
		</div>
	</div>
	<!-- 没中奖显示 -->
	<div id="mzj" class="cj">
		<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20200929mzj.jpg" />
		<p style="width:200px;text-align:center;margin-left:-100px;color:#fff;position:absolute;left:50%;bottom:70px;">
			每人每天有三次抽奖机会哦~</p>
		<a class="ok" ng-click="okClick()"
			style="width:100px;text-align:center;margin-left:-50px;padding:8px 20px;border:1px solid #fff;border-radius:5px;color:#fff;position:absolute;left:50%;bottom:30px;">确定</a>
	</div>
	<!-- 中奖了显示 -->
	<div id="zjl" class="cj">
		<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20200929zjl.jpg" />
		<p style="width:200px;text-align:center;margin-left:-100px;color:#fff;position:absolute;left:50%;bottom:70px;">
			每人每天有三次抽奖机会哦~</p>
		<a class="ok" ng-click="okClick()"
			style="width:100px;text-align:center;margin-left:-50px;padding:8px 20px;border:1px solid #fff;border-radius:5px;color:#fff;position:absolute;left:50%;bottom:30px;">确定</a>
		<i class="prize"></i>
	</div>
	<!-- 神秘抽奖显示 -->
	<div id="smcj">
		<div class="dialog">
			<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/close.png" alt="關閉" class="closeDialog">
			<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20201220bwb.png" alt="神秘抽奖">
			<p>您获得1次额外抽奖机会！</p>
			<button id="lijichoujiang" ng-click="lijichoujiang()">立即抽奖</button>
		</div>
	</div>
	<input id="extName" type="hidden" value="" />
	<input id="actid" type="hidden" value="88" />
	<script src="/js/wxshare.js?v=1"></script>

	<script language="javascript" type="text/javascript">
		var wCount = 0;
		var timer = null;

		timer = setInterval(function () {
			if (wCount < 95) {
				wCount++;
				$('.squre').css('width', wCount * 2 + 'px');
				$('.num').html(wCount + '%');
			} else {
				clearInterval(timer);
			}
		}, 10);

		$(window).load(function () {
			if (timer) {
				clearInterval(timer);
				$('.squre').css('width', '200px');
				$('.num').html('100%');

				setTimeout(function () {
					$('loading').hide();
					$('.rule').show();
				}, 500)
			} else {
				$('.squre').css('width', '200px');
				$('.num').html('100%');
				setTimeout(function () {
					$('loading').hide();
					$('.rule').show();
				}, 500)
			}
		})

		var showlock = false;

		$('#showrule').click(function () {
			if (showlock) {
				$('.rule-text').hide();
				showlock = false;
			} else {
				$('.rule-text').show();
				showlock = true;
			}
		})




		wx.ready(function () {
			$('#audio1')[0].play();
		});
		var lock = false;
		$('.music').click(function(){
			if(!lock){
				lock = true;
				$('#audio1')[0].pause();
				$('#closeMusic').css('display', 'none');
				$('#openMusic').css('display', 'block');
			}else{
				lock = false;
				$('#audio1')[0].play();
				$('#closeMusic').css('display', 'block');
				$('#openMusic').css('display', 'none');
			}
		})
		//var showanswer=false;
		var answershared = false;
		var remainplaytimes = 3;
		$('#close').click(function () {
			$('.show_message').hide();
			$('#zj').hide();
			lock = false;
		})
		$('#mzj').click(function () {
			$('.show_message').hide();
			$('#mzj').hide();
			lock = false;
		})
		var creactanswernum = 0;
		var lottery = {

			index: 1,	//当前转动到哪个位置，起点位置
			count: 0,	//总共有多少个位置
			timer: 0,	//setTimeout的ID，用clearTimeout清除
			speed: 20,	//初始转动速度
			times: 0,	//转动次数
			cycle: 50,	//转动基本次数：即至少需要转动多少次再进入抽奖环节
			prize: -1,	//中奖位置
			init: function (id) {
				if ($("#" + id).find(".lottery-unit").length > 0) {
					$lottery = $("#" + id);
					$units = $lottery.find(".lottery-unit");
					this.obj = $lottery;
					this.count = $units.length;
					$lottery.find(".lottery-unit-" + this.index).addClass("active");
				};
			},
			roll: function () {
				var index = this.index;
				var count = this.count;
				var lottery = this.obj;
				$(lottery).find(".lottery-unit-" + index).removeClass("active");
				index += 1;
				if (index > count) {
					index = 1;
				};
				$(lottery).find(".lottery-unit-" + index).addClass("active");
				this.index = index;
				return false;
			},
			stop: function (index) {
				this.prize = index;
				return false;
			}
		};
		var showMsg = '';
		var recordid = null;
		function roll() {
			lottery.times += 1;
			lottery.roll();
			if (lottery.times > lottery.cycle + 10) {
				clearTimeout(lottery.timer);
				// if (showMsg.data.isprize == 0) {
				// 	window.setTimeout(function () {
				// 		remainplaytimes -= 1;
				// 		if (remainplaytimes >= 0) {
				// 			$("#playtimes").text(remainplaytimes);
				// 		}
				// 		/* showMsgbox('',''); */
				// 		showMsg.showcontent = 0;
				// 		$('#mzj').show();

				// 		/* setTimeout(function(){
						
				// 		if(remainplaytimes>0){
				// 			$('.show_message').hide();
				// 			$('#mzj').hide();
				// 			lock = false;
				// 		}else{
				// 			$('.show_message').hide();
				// 			$('#mzj').hide();
				// 			lock = false;
				// 		}
							
				// 		},2000)  */
				// 	}, 800);
				// } else 
				if (showMsg.data.isprize == 1) {

					window.setTimeout(function () {
						remainplaytimes -= 1;
						if (remainplaytimes >= 0) {
							$("#playtimes").text(remainplaytimes);
						}
						$('.content').css('opacity', 0);
						$('.content').css('height', '20px');
						$('#zjl').show();
						$('.prize').html('&yen ' + showMsg.data.name);
						//showMsgbox('恭喜您获得'+showMsg.data.name,'请填写收奖电话号码');
						showMsg.showcontent = 1;
						/* setTimeout(function(){
						
						if(remainplaytimes>0){
							$('.show_message').hide();
							$('#zjl').hide();
							lock = false;
						}else{
							$('.show_message').hide();
							lock = false;
						}
						
							
						},3000)  */
					}, 800);
				} else { // 修改：当showMsg.data.isprize不为1时就判断为未中奖
					window.setTimeout(function () {
						remainplaytimes -= 1;
						if (remainplaytimes >= 0) {
							$("#playtimes").text(remainplaytimes);
						}
						showMsg.showcontent = 0;
						$('#mzj').show();
					}, 800);
				}
				// else if (showMsg.data.isprize == 2) {
				// 	window.setTimeout(function () {

				// 		// remainplaytimes += 1;
				// 		$("#playtimes").text(remainplaytimes);

				// 		showMsgbox('恭喜您又获得一次抽奖机会', '');
				// 		showMsg.showcontent = 0;
				// 	}, 800);
				// }

				lottery.prize = -1;
				lottery.times = 0;
				click = false;
			} else {
				if (lottery.times < lottery.cycle) {
					lottery.speed -= 10;
				} else if (lottery.times == lottery.cycle) {
					var index = Math.random() * (lottery.count) | 0;
					//lottery.prize = index;		
				} else {
					if (lottery.times > lottery.cycle + 10 && ((lottery.prize == 0 && lottery.index == 7) || lottery.prize == lottery.index + 1)) {
						lottery.speed += 110;
					} else {
						lottery.speed += 20;
					}
				}
				if (lottery.speed < 40) {
					lottery.speed = 40;
				};
				//console.log(lottery.times+'^^^^^^'+lottery.speed+'^^^^^^^'+lottery.prize);
				lottery.timer = setTimeout(roll, lottery.speed);
			}
			return false;
		}

		var lock = false;
		var click = false;
		var cobj = $('#playtimes');
		var playtimes = 0;
		var oTurntable = document.getElementById('pointer');

		window.onload = function () {
			lottery.init('lottery');


			$("#play").on('click', function () {
				// if (lock) { // 此处由于在音乐关闭时无法进行抽奖的点按所以注释了
				// 	return;
				// }
				lock = true;
				var rdm = 0;

				if (click) {
					return false;
				} else {
					if (remainplaytimes <= 0) {
						alert("很遗憾，没有剩余的摇奖次数了。");
						return false;
					}



					//remainplaytimes=remainplaytimes-1;
					$("#playtimes").text(remainplaytimes);
					var extName = $("#extName").val();
					var actid = $("#actid").val();

					$.ajax({
						type: "POST",
						dataType: "json",
						url: "/wx/prize/tryit3.htm",
						data: { "id": actid },// 
						success: function (data) {
							if (data.success == true) {

								var cat = 45;
								var num = 0;
								var offOn = true;
								document.title = "";
								var timer = null;
								rdm = rdm + (Math.floor(Math.random() * 10) + 5) * (360 + 45);


								clearInterval(timer);
								timer = setInterval(function () {
									if (Math.floor(rdm / 360) < 3) {
										rdm = Math.floor(Math.random() * 10) * (360 + 45);
										//rdm+
									} else {
										var rdm2 = rdm + 22.5;
										oTurntable.style.transform = "rotate(" + rdm2 + "deg)";
										clearInterval(timer);
										setTimeout(function () {
											num = rdm % 360;

										}, 4000);
									}
								}, 30);

								lottery.stop(data.data.seq);
								lottery.speed = 100;
								roll();

								click = true;

								showMsg = { data: data.data, showcontent: data.data.isprize };
								recordid = data.recordid;


								return false;
							}
							else {
								alert(data.msg);
							}
						}
					});

				}
			});
		};
		// $('.ok').on('click', function () {
		// 	closeMsgbox();
		// 	$('.cj').hide();
		// 	lock = false;
		// });



		//fetch params
		function req(key) {
			var val = location.search.match(new RegExp("[\?\&]" + key + "=([^\&]*)(\&?)", "i"));
			if (val && val.length >= 2) {
				return val[1];
			}
			return null;
		}

		var id = "402881d97622ed0201767e799f370ba0";
		var firsttime = 0;
		var cor = 0;
		var num = 0;
		var app = angular.module('myApp', []);
		app.controller('customersCtrl', function ($scope, $http) {
			// $scope.cardshow = false; // 答题页（第二页面）
			// $scope.gameshow = false; // 抽奖页面(第三页面，转盘)
			// $scope.zjlshow = false; // 保温杯中奖页面(第四页面1)
			// $scope.mzjshow = false; // 保温杯没中奖页面(第四页面2)
			controller($scope, $http);
			$scope.playagain = function playagain() {
				controller($scope, $http);
			}
			$scope.okClick = function() {
				$('.cj').hide();
				if(remainplaytimes === 0) {
					if($scope.flag) { // 当flag为true时，说明有资格进行神秘抽奖，页面开启后，将flag设为false;防止多次打开
						$scope.flag = !$scope.flag;
						$('#smcj').show();
					}
				}
			}
			$scope.lijichoujiang = function() { // 点击立即抽奖，打开抽奖页面并进行后台请求
				$http.get("/wx/prize/tryit5.htm")
					.success(function(res) {
						if(res.success) {
							$scope.zjlshow = true;
							// 中奖后记录有奖记录ID
							alert(res.msg);
							$scope.zjlId = res.recordid; 
						} else {
							if(res.recordid) { // 有中奖记录
								$scope.zjlshow = true;
								$scope.zjlId = res.recordid; 
							} else {
								$scope.mzjshow = true;
							}
						}
					})
				$('#smcj').css('display', 'none');
				$scope.gameshow = false;
			}
			$scope.bgckGame = function() { // 未中奖后点击知道了返回转盘界面
				$scope.mzjshow = false;
				$scope.gameshow = true;
			}
			$scope.submitForm = function() { // 中奖后提交表单
				let name = document.getElementById("formName");
				let tel = document.getElementById("formTel");
				let place = document.getElementById("formPlace");
				if(name.value && tel.value && place.value) {
					$http({
						url: "/wx/prize/updateAddr.htm", //请求的url路径
						method: "POST",    //GET/DELETE/HEAD/JSONP/POST/PUT
						params: {
							"id": $scope.zjlId,
							"addr": name.value + ' ' + tel.value + ' ' + place.value
						}, //包含了将被当做消息体发送给服务器的数据，通常在POST请求时使用meth
					}).success(function(res) {
						if(res.success) {
							// alert("提交成功");
							alert(res.msg);
							// 提交后返回转盘界面
							$scope.zjlshow = false;
							$scope.gameshow = true;
						} else {
							alert(res.msg);
						}
					})
				} else {
					alert("请填写完整！")
				}
			}
		});

		function initialcard($scope, card) {
			$scope.block = false;

			$scope.card = card;
			$scope.card.questions = card.description.split(",");
			//setTimeout(function(){
			//$('li').css('background','#fff');
			//},500);
			$('li').css('background', '#fff');
			$('li').children('div').children('.correct').css('display', 'none');
			$('li').children('div').children('.error').css('display', 'none');
		}
		function controller($scope, $http) {

			if (firsttime == 0) {
				$scope.firstpageshow = true; // 首页面
			} else {
				remainplaytimes += 1;
				$("#playtimes").text(remainplaytimes);
				remainplaytimes += 1;//可玩次数+1
				$scope.firstpageshow = false;
				$scope.cardshow = true;
				$('.again').hide();
				$('.nextq').show();
				$('#post_answer').hide();
				cor = 0;

			}
			firsttime += 1;
			$scope.nextquestion = "再来一题";
			$scope.answershow = false;
			$scope.gameshow = false;
			$scope.postAnswer = postAnswer;
			$scope.goback = goback;
			function goback() {

				$scope.gameshow = true;
				$scope.answershow = false;
				$("#answers").hide();
			}
			function postAnswer() {
				if (cor < 5) {
					$('.again').show();
				} else if (cor == 5) {
					$scope.gameshow = true;
					$scope.cardshow = false;
				}
			}
			$scope.showfirstpage = function () {
				$scope.firstpageshow = false;
				$scope.cardshow = true;
			}
			$http.get("/wx/prize/totryit5.htm")
				.success(function(res) {
					$scope.flag = res.success;
				})
			$http.get("/wx/prize/listRowsByQueryIdJson.chtm?count=5&id=" + id)
				.success(function (response) {
					$scope.oldcards = [];

					$scope.list = response;
					$scope.size = response.length;
					$scope.currentid = 0;
					$scope.creactanswernum = 0;
					$scope.grade = 0;
					$scope.level = '';
					$scope.mp3path = '';
					initialcard($scope, $scope.list[0]);
					$scope.share = share;
					$scope.hideopa = hideopa;

					function hideopa() {
						$('#opa').css('display', 'none');
					}

					function share() {
						$('#opa').css('display', 'block');
					}



					$scope.next = function () {
						if ($scope.card.myanswer == undefined) {
							alert("请先选择一个答案！");
							return;
						}
						$('.title-desc').hide();
						// $('.con').css('top', '80px');
						var oldcard = angular.copy($scope.card);
						$scope.oldcards.push(oldcard);
						if ($scope.oldcards.length == 4) {
							$('.nextq').css('display', 'none')
						}

						if ($scope.currentid < ($scope.list.length - 1)) {

							$scope.currentid = $scope.currentid + 1;
							var card = $scope.list[$scope.currentid];

							initialcard($scope, card);

						} else {
							// alert('1')
							// for (var i = 0; i < $scope.oldcards.length; i++) {
							// 	var oldcard = $scope.oldcards[i];
							// 	if (oldcard.answer == oldcard.myanswer) {
							// 		$scope.creactanswernum = $scope.creactanswernum + 1;
							// 		$scope.grade = 5 * $scope.creactanswernum;
							// 		if ($scope.creactanswernum < 12) {
							// 			$scope.level = '不及格';
							// 		} else if ($scope.creactanswernum >= 12 && $scope.creactanswernum < 16) {
							// 			$scope.level = '及格';
							// 		} else if ($scope.creactanswernum >= 16 && $scope.creactanswernum < 18) {
							// 			$scope.level = '良好';
							// 		} else {
							// 			$scope.level = '优秀';
							// 		}
							// 		oldcard.correct = true;



							// 	} else {
							// 		$scope.level = '不及格';
							// 	}

							// }
							// $scope.creactrate = Math.round($scope.creactanswernum / $scope.list.length * 100) + "%";
							// weixintitle = $scope.grade + '分！我参加了十九大精神网上学习答题活动！';
							// description = $scope.grade + '分！' + description;


							// $scope.cardshow = false;
							// $scope.gameshow = true;
							// weixinsharetimeline();
							// weixinshareapp();
						}
					}
					$scope.block = false;

					$scope.answerquestion = function (x, index, $event) {
						if (!$scope.block) {
							$scope.block = true;
							$event.stopPropagation();
							$scope.card.myanswer = x;
							if ($scope.oldcards.length < 4) {
								if ($scope.card.answer == x) {
									cor++;
									$($event.target).parent().css('background', '#c7ffca');
									$($event.target).next('div').children('.correct').css('display', 'block');
									setTimeout(function () {
										//$scope.next();
										$scope.$apply();

									}, 1000);
								} else {
									var i = $scope.card.questions.indexOf($scope.card.answer);
									$($event.target).parent().css('background', '#f4d5d6');
									$($event.target).next('div').children('.error').css('display', 'block');
									$('li').eq(i).css('background', '#c7ffca');
									$('li').eq(i).children('div').children('.correct').css('display', 'block');
									setTimeout(function () {
										//$scope.next();

										$scope.$apply();

									}, 1000);


								}
							} else {
								if ($scope.card.answer == x) {
									cor++;
									$($event.target).parent().css('background', '#c7ffca');
									$($event.target).next('div').children('.correct').css('display', 'block');
								} else {
									var i = $scope.card.questions.indexOf($scope.card.answer);
									$($event.target).parent().css('background', '#f4d5d6');
									$($event.target).next('div').children('.error').css('display', 'block');
									$('li').eq(i).css('background', '#c7ffca');
									$('li').eq(i).children('div').children('.correct').css('display', 'block');
								}
								$('#post_answer').css('display', 'block');
							}
						} else {
							return;
						}

						weixinsharetimeline();
						weixinshareapp();
					}
					$scope.showanswers = function () {
						//$scope.answershow=true;

						$scope.gameshow = false;
						$scope.answershow = true;
						$("#answers").show();
					}

				});
		}

		function showMsgbox(title, content) {
			var $msgBox = $('.msgbox');
			$msgBox.children(".title").text(title);
			var addr = "<textarea id='addr' style='width:90%;'></textarea>";
			if (showMsg.showcontent == 0 || showMsg.showcontent == 2) {
				$msgBox.children(".content").html(content);
			}
			else {
				$msgBox.children(".content").html(content + "<br>" + addr);
			}

			$msgBox.parent().show();
		}
		//close msgbox
		function closeMsgbox() {
			var $msgBox = $('.msgbox');

			if (recordid != null) {
				var addr = $("#addr").val();

				$.ajax({
					type: "POST",
					dataType: "json",
					url: "/wx/prize/updateAddr.chtm",
					data: { "id": recordid, "addr": addr },// 
					success: function (data) {
						if (data.success == true) {

						}
						else {
							alert(data.msg);
						}
					}
				});

			}

			$msgBox.children(".content").html('');
			$msgBox.parent().hide();


		}
		
		// 神祕抽獎關閉按鈕
		$('.closeDialog').click(function() {
			$('#smcj').css('display', 'none');
		})


		var weixintitle = 'OYEA双重福利即刻开启！这可能是今冬最暖的遇见~'; // 第十期题目
		var sharecode = "http://xinhua.mofangdata.cn/huangpuchoujiang2019";//分享链接(固定，只换重定向链接)

		var imgurl = "http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20201220share.png"; // 分享描述缩略图
		var description = "限时狂欢来咯~"; //朋友圈分享描述

		shareweixin();

	</script>
	</div>

		<div id="weixinguide" style="display:none;position:absolute;z-index:19999;background-color:#000;width:100%;height:1000px;opacity:0.9;filter:alpha(opacity=90); top:0px;"><img src="/images/guide1.png" style="float:right;top:0;"></div>
</body>

</html>

--------------------------------------------

2020-12-28 10:58:02
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/totryit5.htm
[method] GET
[resBody]
{"msg":"很抱歉，您暂时无法参加此次活动！","success":false}

--------------------------------------------

2020-12-28 10:58:02
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/listRowsByQueryIdJson.chtm?count=5&id=402881d97622ed0201767e799f370ba0
[method] GET
[resBody]
[{"id":"402881d97622ed0201767e7dd3730ba4","queryId":"402881d97622ed0201767e799f370ba0","name":"以下哪种物质不属于有害化学物质？","description":"A.农药,B.二噁英,C.多环芳烃,D.氯化钠","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":3,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.氯化钠","values":null},{"id":"402881d97622ed0201767e7dd3710ba3","queryId":"402881d97622ed0201767e799f370ba0","name":"下列食品中，哪种食品不属于国家实行严格监督管理的特殊食品？","description":"A.保健食品,B.特殊医学用途配方食品,C.婴幼儿配方食品,D.食用油","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":2,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.食用油","values":null},{"id":"402881d97622ed0201767e7dd3770ba6","queryId":"402881d97622ed0201767e799f370ba0","name":"从事接触直接入口食品工作的食品生产经营人员应当每（  ）进行健康检查，取得健康证明后方可上岗工作。","description":"A.半年,B.一年,C.两年,D.三年","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":5,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"B.一年","values":null},{"id":"402881d97622ed0201767e7dd3750ba5","queryId":"402881d97622ed0201767e799f370ba0","name":"《食品安全法》______食品生产经营企业参加食品安全责任保险。","description":"A.强制性要求,B.鼓励,C.限制,D.尚没有明确规定","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":4,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"B.鼓励","values":null},{"id":"402881d97622ed0201767e7dd36f0ba2","queryId":"402881d97622ed0201767e799f370ba0","name":"因食品安全犯罪被判处有期徒刑以上刑罚的，（ ）。","description":"A.刑满一年后可从事食品生产经营管理工作,B.刑满二年后可从事食品生产经营管理工作,C.刑满三年后可从事食品生产经营管理工作,D.终身不得从事食品生产经营管理工作","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":1,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.终身不得从事食品生产经营管理工作","values":null}]

--------------------------------------------

2020-12-28 10:59:43
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/game/answercard.htm?id=402881d97622ed0201767e799f370ba0&prizeid=88&basescope=true&cardid=hpcj2020-10&backGroupId=ed4f2e0737334907ab811b17e316d164
[method] GET
[resBody]









<!DOCTYPE html>
<html lang="zh-CN" >
<head>
 <base href="http://xinhua.mofangdata.cn:80/">
 <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
     <link rel="stylesheet" href="http://apps.bdimg.com/libs/bootstrap/3.3.0/css/bootstrap.min.css">
  <script src="http://apps.bdimg.com/libs/angular.js/1.3.9/angular.min.js"></script>
     <!--  <script src="http://cdn.bootcss.com/angular-ui-bootstrap/0.14.3/ui-bootstrap-tpls.js"></script> -->
   <script src="http://apps.bdimg.com/libs/jquery/2.1.1/jquery.min.js"></script>
   <script src="http://apps.bdimg.com/libs/bootstrap/3.3.0/js/bootstrap.min.js"></script>
   <script src="/js/angular-notify.js"></script>
      <script src="/js/moment.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

    
	
	<style>
		html body {
			width: 100%;
			height: 100%;
			padding: 0px;
			margin: 0px;
		}

		.centent {
			position: absolute;
			width: 100%;
			height: 100%;
			background: url(http://msite.mofangdata.cn/page/wx/prize/gameimages/bg.jpg);
			background-size: 100% 100%;
		}

		#lottery {
			width: 300px;
			height: auto;
			margin: 0 auto 0;
			/*background:url(/resource/img/prize/bg.png) no-repeat;background-size:cover;*/
		}

		#lottery table td {
			width: 100px;
			height: 100px;
			text-align: center;
			vertical-align: middle;
			font-size: 24px;
			color: #333;
		}

		#lottery table td a {
			width: 100px;
			height: 100px;
			display: block;
			text-decoration: none;
		}

		#lottery table td img {
			height: 100px;
		}

		#lottery table td.active {
			background-color: #ea0000;
		}

		.intro {
			background: rgba(255, 255, 255, 0.5);
			border-radius: 5px;
			width: 85%;
			margin: 15px auto;
			padding: 12px;
			color: #fff;
			font-size: 12px;
		}

		.intro h3 {
			text-align: center;
			font-size: normal;
			margin-bottom: 8px;
		}

		.show_message {
			width: 85%;
			position: absolute;
			left: 0;
			right: 0;
			z-index: 10;
			top: 30%;
			margin: auto;
			display: none;
		}

		.msgbox {
			width: 90%;
			height: 30%;
			border-radius: 10px;
			background: #fff;
			position: relative;
			margin: 5% auto;
			z-index: 1000;
		}

		.msgbox .title {
			color: #ff6633;
			border-top-left-radius: 10px;
			border-top-right-radius: 10px;
			background: #ffcc66;
			padding: 2%;

		}

		.msgbox .content {
			color: #666666;
			text-align: center;
			/*padding: 0 1rem;*/
			height: 90px;
			line-height: 90px;
		}

		.msgbox .ok {
			margin: 0 auto;

			color: #555555;
			text-decoration: none;
		}

		#playcount {
			position: absolute;
			font-size: 11px;
			color: #ef8619;
			margin-top: -15px;
			left: 50%;
			padding-left: -9px;
			margin-left: -24px;
		}

		.bottom {
			width: 95%;
			margin: 15px auto;
			text-align: center;
			font-size: 14px;
		}

		.txt {
			margin: 13px auto;
			position: absolute;
			top: 0;
			left: 0;
			bottom: 0;
			right: 0;
		}

		#mainbody {
			max-width: 600px;
		}

		.centents {
			max-width: 800px;
			margin: auto;
			left: 0px;
			top: 0px;
			right: 0px;
			bottom: 0px;
		}

		.loading {
			width: 100%;
			height: 100%;
			background: url('http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20180731loading.png') no-repeat;
			background-size: 100%;
			position: absolute;
			left: 0;
			top: 0;
		}

		.loading .bar {
			width: 200px;
			height: 6px;
			position: absolute;
			left: 50%;
			top: 55%;
			margin-left: -100px;
			border: 1px solid #82cbf9;
			vorder-radius: 3px;
		}

		.num {
			position: absolute;
			right: -40px;
			top: -7px;
			color: #299b13;
			height: 20px;
		}

		.squre {
			width: 0;
			height: 4px;
			background: #299b13;
			position: absolute;
			left: 0;
			top: 0;
		}

		.rule {
			width: 100%;
			height: 100%;
			background: url('http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20201220bg.png') no-repeat;
			background-size: 100% 100%;
			position: absolute;
			left: 0;
			top: 0;
			display: none;
		}

		.text {
			margin-left: 5%;
			margin-top: 20%;
			width: 90%;
			margin-bottom: 100px;
			animation: mymove 1s;
			opacity: 0;
		}

		@keyframes mymove {
			0% {
				transform: scale(0);
			}

			100% {
				transform: scale(1);
			}
		}

		.tools {
			width: 100%;
			height: 40px;
			text-align: center;
			position: absolute;
			left: 0;
			top: 80%;
		}
		.tools #showrule {
			color: #ffffff;
			font-weight: 700;
			position: absolute;
			top: 8px;
			margin-left: 5px;
		}

		.tools img {
			width: 120px;
			height: 39px;
		}

		.rule-text {
			width: 80%;
			margin-left: 10%;
			margin-top: 10px;
			padding: 10px 20px;
			border: 1px solid #07a4eb;
			border-radius: 10px;
			background: #fff;
			position: relative;
			text-align: justify;
			text-indent: 2em;
			display: none;
		}

		.sin {
			width: 10px;
			height: 10px;
			border-top: 1px solid #07a4eb;
			border-left: 1px solid #07a4eb;
			background: #fff;
			position: absolute;
			right: 20%;
			top: -6px;
			transform: rotate(45deg);
		}

		.cj {
			width: 100%;
			height: 100%;
			position: absolute;
			left: 0;
			top: 0;
			z-index: 500;
			background: rgba(0, 0, 0, 0.8);
			display: none;
		}

		.cj img {
			width: 100%;
			margin-top: -50px;
		}

		.prize {
			color: #fbda30;
			position: absolute;
			width: 100px;
			text-align: center;
			font-size: 26px;
			left: 50%;
			margin-left: -50px;
			top: 40%;
			font-style: normal;
			font-family: Arial;

		}

		#smcj {
			width: 100%;
			height: 100vh;
			position: absolute;
			left: 0;
			top: 0;
			z-index: 500;
			background: rgba(0, 0, 0, 0.8);
			display: none;
		}
		#smcj .dialog {
			width: 80%;
			height: 400px;
			border-radius: 12px;
			position: absolute;
			left: 0;
			top: 0;
			right: 0;
			bottom: 0;
			margin: auto;
			background-color: #fff;
			text-align: center;
		}
		#smcj .dialog .closeDialog {
			width: 32px;
			height: 32px;
			position: absolute;
			top: 10px;
			right: 10px;
			margin: 0;
		}
		#smcj .dialog img {
			margin-top: 20px;
			width: 100%;
		}
		#smcj .dialog p {
			padding: 20px 0;
			font-size: 18px;
			font-weight: 700;
		}
		#smcj .dialog button {
			width: 50%;
			height: 40px;
			border: none;
			border-radius: 25px;
			background-color: #ffa718;
			color: #fff;
			font-size: 18px;
			font-weight: 700;
		}
		.bwbzjl {
			background-color: #e80200;
		}
		.bwbzjl img {
			width: 100%;
		}
		.bwbzjl #form {
			width: 100%;
			height: 450px;
			padding: 0 35px;
		}
		.bwbzjl p {
			color: #fff;
			padding-top: 10px;
		}
		.bwbzjl input, .bwbzjl textarea {
			width: 100%;
			border-radius: 5px;
		}
		.bwbzjl button, .bwbmzj button {
			display: block;
			margin-top: 15px;
			width: 100%;
			height: 40px;
			border: none;
			border-radius: 25px;
			background-color: yellow;
			color: red;
			font-size: 18px;
			font-weight: 700;
		}
		.bwbmzj {
			height: 100vh;
			background-color: #fff6dd;
			padding: 80px;
		}
		.bwbmzj img {
			width: 100%;
		}
		.bwbmzj button {
			margin-top: 40px;
			background-color: red;
			color: #fff;
		}
	</style>

<title> 食品安全知识问答</title>
</head>

<body ng-app="myApp" ng-controller="customersCtrl">

	

	<div id="mainbody">
		<!-- 首页面 -->
		<div style="width: 100%;height:100%;" ng-show="firstpageshow">
			<div class="loading">
				<div class="bar">
					<i class="num">0</i>
					<i class="squre"></i>
				</div>
			</div>
			<div class="rule">
				<!-- 首页rule -->
				<div class="tools">
					<!-- <img id="showrule" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200820rule.png"
						style="margin-right:48px;" /> -->
					<img ng-click="showfirstpage()" id="startgame"
						src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20201220start.png" />
					<span id="showrule">活动规则></span>
					<div class="rule-text">
						<div class="sin"></div>
						食品安全知识有奖问答活动周期十个月，每月一期，为期一周，每期五题。五题答对即可抽奖。十期问题全部答对的网友，更有机会获得额外的抽奖机会哦~祝你好运！
					</div>

				</div>
			</div>
		</div>
		<!-- 失败页面，答题未通过时展示 -->
		<div class="again" style="width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000;display:none;">
			<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200319againbg.png"
				style="width:100%;height:100%;" />
			<a class="again-btn" ng-click="playagain()"
				style="width:100%;height:40px;position:absolute;left:0;bottom:20%;text-align:center;">
				<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200319againbtn.png"
					style="height:40px;" /></a>
		</div>
		<!-- 音量按钮，定位左上角 -->
		<div class="music" style="position:absolute;top:2%;right:3%;z-index:9999;">
			<img id="closeMusic" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20180117nyj-music.png" style="width:25px;" />
			<img id="openMusic" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20200114-stop.png" style="width:25px; display: none;" />
			<audio id="audio1" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20180723music.mp3"
				style="opacity:1;" autoplay="autoplay"></audio>
		</div>
		<!-- 答题页面，即第二页面（容器） -->
		<div ng-show="cardshow"
			style="width:100%; height: 100%; position:absolute; background:url(http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20201220answerbg.png) no-repeat; background-size:100% 100%;"
			class="centents">
		</div>
		<!-- 题目页面，即第二页面（内容） -->
		<div class="con" ng-show="cardshow" style="width:84%; position:absolute;left:0;right:0;top:18%;margin:0 auto;">
			<div style="margin-left:1%;font-size:1.3rem;">
				<h4 style="color:#166bbd;font-size:16px;line-height:20px;"><span ng-bind="card.name"></span></h4>
			</div>


			<div style="padding: 0">
				<ul id="answer_list" style="margin-left:-38px;">
					<li id="{{x}}" on-finish ng-repeat="x in card.questions track by $index"
						style="border:1px dashed #aaafb3;font-size:1.3rem;position:relative;border-radius:10px;margin-bottom:6px;list-style:none;width:100%;padding:0px 10px;color:#000;background:transparent;">
						<div ng-click="answerquestion(x,$index,$event)">{{index}}{{x}}</div>
						<div style="width:15px;height:15px;position:absolute;right:2px;top:20%;">
							<img class="correct" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/answer19dadui.png"
								style="width:100%;display:none;" />
							<img class="error" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/answer19dax.png"
								style="width:100%;display:none;" />
						</div>
					</li>

				</ul>
				<div class="nextq"
					style="width:94%;margin-left:3%;border-radius:10px;text-align:center;margin-top:10px;">
					<img ng-click="next()" src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20201220next.png"
						style="height:30px;" />
				</div>

			</div>
			<div id="post_answer"
				style="width:94%;margin-left:3%;border-radius:10px;text-align:center;display:none;margin-top:0px;"
				ng-click="postAnswer()">
				<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20201220next.png" style="height:30px;" />
			</div>

		</div>
	</div>
	<!--抽奖页面-->
	<div class="centents ng-hide" ng-show="gameshow" style="background: url('http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200323cjbg.png'); background-size:100% 100%;position:absolute;width: 100%;height: 100%; ">
		<div id="pointer" class="pointer" style="transform-origin:49.7% 48.4%;transition: all 4s;width:100%;height:100%;position:absolute;left:0;top:0;background:url('http://msite.mofangdata.cn/page/wx/prize/gameimages/cj20200319click.png') no-repeat; background-size:100% 100%;"></div>
		<div id="play" ng-click="testClick()" style="width:15%;height:10%;position:absolute;left:42%;top:44%;"></div>
	</div>
	<!-- 中奖页面（保温杯抽奖） -->
	<div class="bwbzjl ng-hide" ng-show="zjlshow">
		<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20201220bwbzjl.png" alt="中奖了">
		<div id="form">
			<p style="color: #fff;">请提交您的个人联系方式，以便发放奖品，不提交将视为自动放弃本次抽奖。</p>
			<p>姓名</p>
			<input type="text" name="name" id="formName" placeholder="请输入您的姓名">
			<p>手机</p>
			<input type="tel" name="tel" onkeyup="value=value.replace(/[^\d]/g,'')" maxlength=11 id="formTel" placeholder="请输入您的手机号码">
			<p>收件地址</p>
			<textarea name="place" id="formPlace" placeholder="请输入您的详细收件地址"></textarea>
			<button ng-click="submitForm()">提交</button>
		</div>
	</div>
	<!-- 未中奖页面（保温杯抽奖） -->
	<div class="bwbmzj ng-hide" ng-show="mzjshow">
		<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20201220bwbmzj.png" alt="没中奖">
		<button ng-click="bgckGame()">知道了</button>
	</div>
	<!-- 具体题目 -->
	<div ng-show="answershow" style="background: none;padding-bottom:20px;">
		<div id="answers" style="display:none;" style="width:80%;">
			<ul>
				<li ng-repeat=" oldcard in oldcards">
					<div>
						<h4><span ng-bind="oldcard.name"></span></h4>
					</div>
					<div>
						正确答案：<span ng-bind="oldcard.answer"></span>
					</div>
				</li>
				</li>
			</ul>
		</div>
	</div>
	<!-- 抽奖结果 -->
	<div class="show_message">
		<div class="msgbox">
			<div class="title">抽奖结果</div>
			<div class="content"></div>
			<div style="text-align:center;width:100%;padding-bottom:5px;">
				<button class="ok btn" ng-click="okClick()" href="javascript:void(0);">确定</button>
			</div>
		</div>
	</div>
	<!-- 没中奖显示 -->
	<div id="mzj" class="cj">
		<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20200929mzj.jpg" />
		<p style="width:200px;text-align:center;margin-left:-100px;color:#fff;position:absolute;left:50%;bottom:70px;">
			每人每天有三次抽奖机会哦~</p>
		<a class="ok" ng-click="okClick()"
			style="width:100px;text-align:center;margin-left:-50px;padding:8px 20px;border:1px solid #fff;border-radius:5px;color:#fff;position:absolute;left:50%;bottom:30px;">确定</a>
	</div>
	<!-- 中奖了显示 -->
	<div id="zjl" class="cj">
		<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20200929zjl.jpg" />
		<p style="width:200px;text-align:center;margin-left:-100px;color:#fff;position:absolute;left:50%;bottom:70px;">
			每人每天有三次抽奖机会哦~</p>
		<a class="ok" ng-click="okClick()"
			style="width:100px;text-align:center;margin-left:-50px;padding:8px 20px;border:1px solid #fff;border-radius:5px;color:#fff;position:absolute;left:50%;bottom:30px;">确定</a>
		<i class="prize"></i>
	</div>
	<!-- 神秘抽奖显示 -->
	<div id="smcj">
		<div class="dialog">
			<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/close.png" alt="關閉" class="closeDialog">
			<img src="http://msite.mofangdata.cn/page/wx/prize/gameimages/20201220bwb.png" alt="神秘抽奖">
			<p>您获得1次额外抽奖机会！</p>
			<button id="lijichoujiang" ng-click="lijichoujiang()">立即抽奖</button>
		</div>
	</div>
	<input id="extName" type="hidden" value="" />
	<input id="actid" type="hidden" value="88" />
	<script src="/js/wxshare.js?v=1"></script>

	<script language="javascript" type="text/javascript">
		var wCount = 0;
		var timer = null;

		timer = setInterval(function () {
			if (wCount < 95) {
				wCount++;
				$('.squre').css('width', wCount * 2 + 'px');
				$('.num').html(wCount + '%');
			} else {
				clearInterval(timer);
			}
		}, 10);

		$(window).load(function () {
			if (timer) {
				clearInterval(timer);
				$('.squre').css('width', '200px');
				$('.num').html('100%');

				setTimeout(function () {
					$('loading').hide();
					$('.rule').show();
				}, 500)
			} else {
				$('.squre').css('width', '200px');
				$('.num').html('100%');
				setTimeout(function () {
					$('loading').hide();
					$('.rule').show();
				}, 500)
			}
		})

		var showlock = false;

		$('#showrule').click(function () {
			if (showlock) {
				$('.rule-text').hide();
				showlock = false;
			} else {
				$('.rule-text').show();
				showlock = true;
			}
		})




		wx.ready(function () {
			$('#audio1')[0].play();
		});
		var lock = false;
		$('.music').click(function(){
			if(!lock){
				lock = true;
				$('#audio1')[0].pause();
				$('#closeMusic').css('display', 'none');
				$('#openMusic').css('display', 'block');
			}else{
				lock = false;
				$('#audio1')[0].play();
				$('#closeMusic').css('display', 'block');
				$('#openMusic').css('display', 'none');
			}
		})
		//var showanswer=false;
		var answershared = false;
		var remainplaytimes = 3;
		$('#close').click(function () {
			$('.show_message').hide();
			$('#zj').hide();
			lock = false;
		})
		$('#mzj').click(function () {
			$('.show_message').hide();
			$('#mzj').hide();
			lock = false;
		})
		var creactanswernum = 0;
		var lottery = {

			index: 1,	//当前转动到哪个位置，起点位置
			count: 0,	//总共有多少个位置
			timer: 0,	//setTimeout的ID，用clearTimeout清除
			speed: 20,	//初始转动速度
			times: 0,	//转动次数
			cycle: 50,	//转动基本次数：即至少需要转动多少次再进入抽奖环节
			prize: -1,	//中奖位置
			init: function (id) {
				if ($("#" + id).find(".lottery-unit").length > 0) {
					$lottery = $("#" + id);
					$units = $lottery.find(".lottery-unit");
					this.obj = $lottery;
					this.count = $units.length;
					$lottery.find(".lottery-unit-" + this.index).addClass("active");
				};
			},
			roll: function () {
				var index = this.index;
				var count = this.count;
				var lottery = this.obj;
				$(lottery).find(".lottery-unit-" + index).removeClass("active");
				index += 1;
				if (index > count) {
					index = 1;
				};
				$(lottery).find(".lottery-unit-" + index).addClass("active");
				this.index = index;
				return false;
			},
			stop: function (index) {
				this.prize = index;
				return false;
			}
		};
		var showMsg = '';
		var recordid = null;
		function roll() {
			lottery.times += 1;
			lottery.roll();
			if (lottery.times > lottery.cycle + 10) {
				clearTimeout(lottery.timer);
				// if (showMsg.data.isprize == 0) {
				// 	window.setTimeout(function () {
				// 		remainplaytimes -= 1;
				// 		if (remainplaytimes >= 0) {
				// 			$("#playtimes").text(remainplaytimes);
				// 		}
				// 		/* showMsgbox('',''); */
				// 		showMsg.showcontent = 0;
				// 		$('#mzj').show();

				// 		/* setTimeout(function(){
						
				// 		if(remainplaytimes>0){
				// 			$('.show_message').hide();
				// 			$('#mzj').hide();
				// 			lock = false;
				// 		}else{
				// 			$('.show_message').hide();
				// 			$('#mzj').hide();
				// 			lock = false;
				// 		}
							
				// 		},2000)  */
				// 	}, 800);
				// } else 
				if (showMsg.data.isprize == 1) {

					window.setTimeout(function () {
						remainplaytimes -= 1;
						if (remainplaytimes >= 0) {
							$("#playtimes").text(remainplaytimes);
						}
						$('.content').css('opacity', 0);
						$('.content').css('height', '20px');
						$('#zjl').show();
						$('.prize').html('&yen ' + showMsg.data.name);
						//showMsgbox('恭喜您获得'+showMsg.data.name,'请填写收奖电话号码');
						showMsg.showcontent = 1;
						/* setTimeout(function(){
						
						if(remainplaytimes>0){
							$('.show_message').hide();
							$('#zjl').hide();
							lock = false;
						}else{
							$('.show_message').hide();
							lock = false;
						}
						
							
						},3000)  */
					}, 800);
				} else { // 修改：当showMsg.data.isprize不为1时就判断为未中奖
					window.setTimeout(function () {
						remainplaytimes -= 1;
						if (remainplaytimes >= 0) {
							$("#playtimes").text(remainplaytimes);
						}
						showMsg.showcontent = 0;
						$('#mzj').show();
					}, 800);
				}
				// else if (showMsg.data.isprize == 2) {
				// 	window.setTimeout(function () {

				// 		// remainplaytimes += 1;
				// 		$("#playtimes").text(remainplaytimes);

				// 		showMsgbox('恭喜您又获得一次抽奖机会', '');
				// 		showMsg.showcontent = 0;
				// 	}, 800);
				// }

				lottery.prize = -1;
				lottery.times = 0;
				click = false;
			} else {
				if (lottery.times < lottery.cycle) {
					lottery.speed -= 10;
				} else if (lottery.times == lottery.cycle) {
					var index = Math.random() * (lottery.count) | 0;
					//lottery.prize = index;		
				} else {
					if (lottery.times > lottery.cycle + 10 && ((lottery.prize == 0 && lottery.index == 7) || lottery.prize == lottery.index + 1)) {
						lottery.speed += 110;
					} else {
						lottery.speed += 20;
					}
				}
				if (lottery.speed < 40) {
					lottery.speed = 40;
				};
				//console.log(lottery.times+'^^^^^^'+lottery.speed+'^^^^^^^'+lottery.prize);
				lottery.timer = setTimeout(roll, lottery.speed);
			}
			return false;
		}

		var lock = false;
		var click = false;
		var cobj = $('#playtimes');
		var playtimes = 0;
		var oTurntable = document.getElementById('pointer');

		window.onload = function () {
			lottery.init('lottery');


			$("#play").on('click', function () {
				// if (lock) { // 此处由于在音乐关闭时无法进行抽奖的点按所以注释了
				// 	return;
				// }
				lock = true;
				var rdm = 0;

				if (click) {
					return false;
				} else {
					if (remainplaytimes <= 0) {
						alert("很遗憾，没有剩余的摇奖次数了。");
						return false;
					}



					//remainplaytimes=remainplaytimes-1;
					$("#playtimes").text(remainplaytimes);
					var extName = $("#extName").val();
					var actid = $("#actid").val();

					$.ajax({
						type: "POST",
						dataType: "json",
						url: "/wx/prize/tryit3.htm",
						data: { "id": actid },// 
						success: function (data) {
							if (data.success == true) {

								var cat = 45;
								var num = 0;
								var offOn = true;
								document.title = "";
								var timer = null;
								rdm = rdm + (Math.floor(Math.random() * 10) + 5) * (360 + 45);


								clearInterval(timer);
								timer = setInterval(function () {
									if (Math.floor(rdm / 360) < 3) {
										rdm = Math.floor(Math.random() * 10) * (360 + 45);
										//rdm+
									} else {
										var rdm2 = rdm + 22.5;
										oTurntable.style.transform = "rotate(" + rdm2 + "deg)";
										clearInterval(timer);
										setTimeout(function () {
											num = rdm % 360;

										}, 4000);
									}
								}, 30);

								lottery.stop(data.data.seq);
								lottery.speed = 100;
								roll();

								click = true;

								showMsg = { data: data.data, showcontent: data.data.isprize };
								recordid = data.recordid;


								return false;
							}
							else {
								alert(data.msg);
							}
						}
					});

				}
			});
		};
		// $('.ok').on('click', function () {
		// 	closeMsgbox();
		// 	$('.cj').hide();
		// 	lock = false;
		// });



		//fetch params
		function req(key) {
			var val = location.search.match(new RegExp("[\?\&]" + key + "=([^\&]*)(\&?)", "i"));
			if (val && val.length >= 2) {
				return val[1];
			}
			return null;
		}

		var id = "402881d97622ed0201767e799f370ba0";
		var firsttime = 0;
		var cor = 0;
		var num = 0;
		var app = angular.module('myApp', []);
		app.controller('customersCtrl', function ($scope, $http) {
			// $scope.cardshow = false; // 答题页（第二页面）
			// $scope.gameshow = false; // 抽奖页面(第三页面，转盘)
			// $scope.zjlshow = false; // 保温杯中奖页面(第四页面1)
			// $scope.mzjshow = false; // 保温杯没中奖页面(第四页面2)
			controller($scope, $http);
			$scope.playagain = function playagain() {
				controller($scope, $http);
			}
			$scope.okClick = function() {
				$('.cj').hide();
				if(remainplaytimes === 0) {
					if($scope.flag) { // 当flag为true时，说明有资格进行神秘抽奖，页面开启后，将flag设为false;防止多次打开
						$scope.flag = !$scope.flag;
						$('#smcj').show();
					}
				}
			}
			$scope.lijichoujiang = function() { // 点击立即抽奖，打开抽奖页面并进行后台请求
				$http.get("/wx/prize/tryit5.htm")
					.success(function(res) {
						if(res.success) {
							$scope.zjlshow = true;
							// 中奖后记录有奖记录ID
							alert(res.msg);
							$scope.zjlId = res.recordid; 
						} else {
							if(res.recordid) { // 有中奖记录
								$scope.zjlshow = true;
								$scope.zjlId = res.recordid; 
							} else {
								$scope.mzjshow = true;
							}
						}
					})
				$('#smcj').css('display', 'none');
				$scope.gameshow = false;
			}
			$scope.bgckGame = function() { // 未中奖后点击知道了返回转盘界面
				$scope.mzjshow = false;
				$scope.gameshow = true;
			}
			$scope.submitForm = function() { // 中奖后提交表单
				let name = document.getElementById("formName");
				let tel = document.getElementById("formTel");
				let place = document.getElementById("formPlace");
				if(name.value && tel.value && place.value) {
					$http({
						url: "/wx/prize/updateAddr.htm", //请求的url路径
						method: "POST",    //GET/DELETE/HEAD/JSONP/POST/PUT
						params: {
							"id": $scope.zjlId,
							"addr": name.value + ' ' + tel.value + ' ' + place.value
						}, //包含了将被当做消息体发送给服务器的数据，通常在POST请求时使用meth
					}).success(function(res) {
						if(res.success) {
							// alert("提交成功");
							alert(res.msg);
							// 提交后返回转盘界面
							$scope.zjlshow = false;
							$scope.gameshow = true;
						} else {
							alert(res.msg);
						}
					})
				} else {
					alert("请填写完整！")
				}
			}
		});

		function initialcard($scope, card) {
			$scope.block = false;

			$scope.card = card;
			$scope.card.questions = card.description.split(",");
			//setTimeout(function(){
			//$('li').css('background','#fff');
			//},500);
			$('li').css('background', '#fff');
			$('li').children('div').children('.correct').css('display', 'none');
			$('li').children('div').children('.error').css('display', 'none');
		}
		function controller($scope, $http) {

			if (firsttime == 0) {
				$scope.firstpageshow = true; // 首页面
			} else {
				remainplaytimes += 1;
				$("#playtimes").text(remainplaytimes);
				remainplaytimes += 1;//可玩次数+1
				$scope.firstpageshow = false;
				$scope.cardshow = true;
				$('.again').hide();
				$('.nextq').show();
				$('#post_answer').hide();
				cor = 0;

			}
			firsttime += 1;
			$scope.nextquestion = "再来一题";
			$scope.answershow = false;
			$scope.gameshow = false;
			$scope.postAnswer = postAnswer;
			$scope.goback = goback;
			function goback() {

				$scope.gameshow = true;
				$scope.answershow = false;
				$("#answers").hide();
			}
			function postAnswer() {
				if (cor < 5) {
					$('.again').show();
				} else if (cor == 5) {
					$scope.gameshow = true;
					$scope.cardshow = false;
				}
			}
			$scope.showfirstpage = function () {
				$scope.firstpageshow = false;
				$scope.cardshow = true;
			}
			$http.get("/wx/prize/totryit5.htm")
				.success(function(res) {
					$scope.flag = res.success;
				})
			$http.get("/wx/prize/listRowsByQueryIdJson.chtm?count=5&id=" + id)
				.success(function (response) {
					$scope.oldcards = [];

					$scope.list = response;
					$scope.size = response.length;
					$scope.currentid = 0;
					$scope.creactanswernum = 0;
					$scope.grade = 0;
					$scope.level = '';
					$scope.mp3path = '';
					initialcard($scope, $scope.list[0]);
					$scope.share = share;
					$scope.hideopa = hideopa;

					function hideopa() {
						$('#opa').css('display', 'none');
					}

					function share() {
						$('#opa').css('display', 'block');
					}



					$scope.next = function () {
						if ($scope.card.myanswer == undefined) {
							alert("请先选择一个答案！");
							return;
						}
						$('.title-desc').hide();
						// $('.con').css('top', '80px');
						var oldcard = angular.copy($scope.card);
						$scope.oldcards.push(oldcard);
						if ($scope.oldcards.length == 4) {
							$('.nextq').css('display', 'none')
						}

						if ($scope.currentid < ($scope.list.length - 1)) {

							$scope.currentid = $scope.currentid + 1;
							var card = $scope.list[$scope.currentid];

							initialcard($scope, card);

						} else {
							// alert('1')
							// for (var i = 0; i < $scope.oldcards.length; i++) {
							// 	var oldcard = $scope.oldcards[i];
							// 	if (oldcard.answer == oldcard.myanswer) {
							// 		$scope.creactanswernum = $scope.creactanswernum + 1;
							// 		$scope.grade = 5 * $scope.creactanswernum;
							// 		if ($scope.creactanswernum < 12) {
							// 			$scope.level = '不及格';
							// 		} else if ($scope.creactanswernum >= 12 && $scope.creactanswernum < 16) {
							// 			$scope.level = '及格';
							// 		} else if ($scope.creactanswernum >= 16 && $scope.creactanswernum < 18) {
							// 			$scope.level = '良好';
							// 		} else {
							// 			$scope.level = '优秀';
							// 		}
							// 		oldcard.correct = true;



							// 	} else {
							// 		$scope.level = '不及格';
							// 	}

							// }
							// $scope.creactrate = Math.round($scope.creactanswernum / $scope.list.length * 100) + "%";
							// weixintitle = $scope.grade + '分！我参加了十九大精神网上学习答题活动！';
							// description = $scope.grade + '分！' + description;


							// $scope.cardshow = false;
							// $scope.gameshow = true;
							// weixinsharetimeline();
							// weixinshareapp();
						}
					}
					$scope.block = false;

					$scope.answerquestion = function (x, index, $event) {
						if (!$scope.block) {
							$scope.block = true;
							$event.stopPropagation();
							$scope.card.myanswer = x;
							if ($scope.oldcards.length < 4) {
								if ($scope.card.answer == x) {
									cor++;
									$($event.target).parent().css('background', '#c7ffca');
									$($event.target).next('div').children('.correct').css('display', 'block');
									setTimeout(function () {
										//$scope.next();
										$scope.$apply();

									}, 1000);
								} else {
									var i = $scope.card.questions.indexOf($scope.card.answer);
									$($event.target).parent().css('background', '#f4d5d6');
									$($event.target).next('div').children('.error').css('display', 'block');
									$('li').eq(i).css('background', '#c7ffca');
									$('li').eq(i).children('div').children('.correct').css('display', 'block');
									setTimeout(function () {
										//$scope.next();

										$scope.$apply();

									}, 1000);


								}
							} else {
								if ($scope.card.answer == x) {
									cor++;
									$($event.target).parent().css('background', '#c7ffca');
									$($event.target).next('div').children('.correct').css('display', 'block');
								} else {
									var i = $scope.card.questions.indexOf($scope.card.answer);
									$($event.target).parent().css('background', '#f4d5d6');
									$($event.target).next('div').children('.error').css('display', 'block');
									$('li').eq(i).css('background', '#c7ffca');
									$('li').eq(i).children('div').children('.correct').css('display', 'block');
								}
								$('#post_answer').css('display', 'block');
							}
						} else {
							return;
						}

						weixinsharetimeline();
						weixinshareapp();
					}
					$scope.showanswers = function () {
						//$scope.answershow=true;

						$scope.gameshow = false;
						$scope.answershow = true;
						$("#answers").show();
					}

				});
		}

		function showMsgbox(title, content) {
			var $msgBox = $('.msgbox');
			$msgBox.children(".title").text(title);
			var addr = "<textarea id='addr' style='width:90%;'></textarea>";
			if (showMsg.showcontent == 0 || showMsg.showcontent == 2) {
				$msgBox.children(".content").html(content);
			}
			else {
				$msgBox.children(".content").html(content + "<br>" + addr);
			}

			$msgBox.parent().show();
		}
		//close msgbox
		function closeMsgbox() {
			var $msgBox = $('.msgbox');

			if (recordid != null) {
				var addr = $("#addr").val();

				$.ajax({
					type: "POST",
					dataType: "json",
					url: "/wx/prize/updateAddr.chtm",
					data: { "id": recordid, "addr": addr },// 
					success: function (data) {
						if (data.success == true) {

						}
						else {
							alert(data.msg);
						}
					}
				});

			}

			$msgBox.children(".content").html('');
			$msgBox.parent().hide();


		}
		
		// 神祕抽獎關閉按鈕
		$('.closeDialog').click(function() {
			$('#smcj').css('display', 'none');
		})


		var weixintitle = 'OYEA双重福利即刻开启！这可能是今冬最暖的遇见~'; // 第十期题目
		var sharecode = "http://xinhua.mofangdata.cn/huangpuchoujiang2019";//分享链接(固定，只换重定向链接)

		var imgurl = "http://msite.mofangdata.cn/page/wx/prize/gameimages/hp20201220share.png"; // 分享描述缩略图
		var description = "限时狂欢来咯~"; //朋友圈分享描述

		shareweixin();

	</script>
	</div>

		<div id="weixinguide" style="display:none;position:absolute;z-index:19999;background-color:#000;width:100%;height:1000px;opacity:0.9;filter:alpha(opacity=90); top:0px;"><img src="/images/guide1.png" style="float:right;top:0;"></div>
</body>

</html>

--------------------------------------------

2020-12-28 10:59:43
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/totryit5.htm
[method] GET
[resBody]
{"msg":"很抱歉，您暂时无法参加此次活动！","success":false}

--------------------------------------------

2020-12-28 10:59:43
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/listRowsByQueryIdJson.chtm?count=5&id=402881d97622ed0201767e799f370ba0
[method] GET
[resBody]
[{"id":"402881d97622ed0201767e7dd3730ba4","queryId":"402881d97622ed0201767e799f370ba0","name":"以下哪种物质不属于有害化学物质？","description":"A.农药,B.二噁英,C.多环芳烃,D.氯化钠","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":3,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.氯化钠","values":null},{"id":"402881d97622ed0201767e7dd3710ba3","queryId":"402881d97622ed0201767e799f370ba0","name":"下列食品中，哪种食品不属于国家实行严格监督管理的特殊食品？","description":"A.保健食品,B.特殊医学用途配方食品,C.婴幼儿配方食品,D.食用油","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":2,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.食用油","values":null},{"id":"402881d97622ed0201767e7dd3750ba5","queryId":"402881d97622ed0201767e799f370ba0","name":"《食品安全法》______食品生产经营企业参加食品安全责任保险。","description":"A.强制性要求,B.鼓励,C.限制,D.尚没有明确规定","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":4,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"B.鼓励","values":null},{"id":"402881d97622ed0201767e7dd36f0ba2","queryId":"402881d97622ed0201767e799f370ba0","name":"因食品安全犯罪被判处有期徒刑以上刑罚的，（ ）。","description":"A.刑满一年后可从事食品生产经营管理工作,B.刑满二年后可从事食品生产经营管理工作,C.刑满三年后可从事食品生产经营管理工作,D.终身不得从事食品生产经营管理工作","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":1,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.终身不得从事食品生产经营管理工作","values":null},{"id":"402881d97622ed0201767e7dd3770ba6","queryId":"402881d97622ed0201767e799f370ba0","name":"从事接触直接入口食品工作的食品生产经营人员应当每（  ）进行健康检查，取得健康证明后方可上岗工作。","description":"A.半年,B.一年,C.两年,D.三年","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":5,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"B.一年","values":null}]

--------------------------------------------

2020-12-28 11:02:10
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/listRowsByQueryIdJson.chtm?count=5&id=402881d97622ed0201767e799f370ba0
[method] GET
[resBody]
[{"id":"402881d97622ed0201767e7dd3770ba6","queryId":"402881d97622ed0201767e799f370ba0","name":"从事接触直接入口食品工作的食品生产经营人员应当每（  ）进行健康检查，取得健康证明后方可上岗工作。","description":"A.半年,B.一年,C.两年,D.三年","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":5,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"B.一年","values":null},{"id":"402881d97622ed0201767e7dd3710ba3","queryId":"402881d97622ed0201767e799f370ba0","name":"下列食品中，哪种食品不属于国家实行严格监督管理的特殊食品？","description":"A.保健食品,B.特殊医学用途配方食品,C.婴幼儿配方食品,D.食用油","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":2,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.食用油","values":null},{"id":"402881d97622ed0201767e7dd3750ba5","queryId":"402881d97622ed0201767e799f370ba0","name":"《食品安全法》______食品生产经营企业参加食品安全责任保险。","description":"A.强制性要求,B.鼓励,C.限制,D.尚没有明确规定","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":4,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"B.鼓励","values":null},{"id":"402881d97622ed0201767e7dd36f0ba2","queryId":"402881d97622ed0201767e799f370ba0","name":"因食品安全犯罪被判处有期徒刑以上刑罚的，（ ）。","description":"A.刑满一年后可从事食品生产经营管理工作,B.刑满二年后可从事食品生产经营管理工作,C.刑满三年后可从事食品生产经营管理工作,D.终身不得从事食品生产经营管理工作","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":1,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.终身不得从事食品生产经营管理工作","values":null},{"id":"402881d97622ed0201767e7dd3730ba4","queryId":"402881d97622ed0201767e799f370ba0","name":"以下哪种物质不属于有害化学物质？","description":"A.农药,B.二噁英,C.多环芳烃,D.氯化钠","backGroupId":"ed4f2e0737334907ab811b17e316d164","format":null,"type":5,"valid":1,"sortorder":3,"value":null,"required":1,"canbemodified":1,"bindUser":null,"showForUser":0,"answer":"D.氯化钠","values":null}]

--------------------------------------------

2020-12-28 11:02:10
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/totryit5.htm
[method] GET
[resBody]
{"msg":"很抱歉，您暂时无法参加此次活动！","success":false}

--------------------------------------------

2020-12-28 11:03:43
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/tryit3.htm
[method] POST
[postBody]
id=88
[resBody]
{"recordid":6184271,"msg":"","data":{"id":561,"actid":88,"name":"谢谢参与","imgurl":"","grade":null,"seq":6,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6184271,"actid":88,"itemid":561,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9cca9c6041e","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2020-12-28 23:03:45","ipaddress":null,"verification":"N6463","paymentNo":null,"moneySum":null}}

--------------------------------------------

2020-12-28 11:03:50
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/tryit3.htm
[method] POST
[postBody]
id=88
[resBody]
{"recordid":6184282,"msg":"","data":{"id":559,"actid":88,"name":"谢谢参与","imgurl":"","grade":null,"seq":4,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6184282,"actid":88,"itemid":559,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9cca9c6041e","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2020-12-28 23:03:53","ipaddress":null,"verification":"N6208","paymentNo":null,"moneySum":null}}

--------------------------------------------

2020-12-28 11:03:58
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/tryit3.htm
[method] POST
[postBody]
id=88
[resBody]
{"recordid":6184328,"msg":"","data":{"id":563,"actid":88,"name":"谢谢参与","imgurl":"","grade":null,"seq":8,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6184328,"actid":88,"itemid":563,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9cca9c6041e","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2020-12-28 23:04:01","ipaddress":null,"verification":"N8689","paymentNo":null,"moneySum":null}}

--------------------------------------------

2020-12-28 11:04:05
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/tryit3.htm
[method] POST
[postBody]
id=88
[resBody]
{"msg":"当前活动每人每天仅能参与3次,下次再试","success":false}

--------------------------------------------

2020-12-28 11:04:07
[host<xinhua.mofangdata.cn>]
[url] http://xinhua.mofangdata.cn/wx/prize/tryit3.htm
[method] POST
[postBody]
id=88
[resBody]
{"msg":"当前活动每人每天仅能参与3次,下次再试","success":false}

--------------------------------------------
