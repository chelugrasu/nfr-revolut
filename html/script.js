var isInMenu = false
var isInRegisterMenu = false
var cod = 0
var pin = 0000
function Display(bool) {
    if (bool) {
        if(!isInRegisterMenu){
            $.post("http://nfr_revolut/verify", JSON.stringify({}));
            openSecondaryMenu("welcome")
            closeSecondaryMenu()
            isInMenu = true
        } else {
            $("#container").fadeIn(750);
            $("#registerPage").show();
            isInMenu = true
        }
    } else {
        $("#container").fadeOut(750);
        $("#welcomePage").fadeOut(500);
        closeSecondaryMenu()
        isInMenu = false
    }
}

function openSecondaryMenu(menuName) {
    $("#withdrawMenu").hide()
    $("#depositMenu").hide()
    $("#transferMenu").hide()
    switch (menuName) {
        case "profile":
            $("#mainUI").hide()
            $("#home").hide()
            $("#profilePage").fadeIn(250)
            closeMenu("home")
            closeMenu("hub")
            closeMenu("rewards")
            break;
        case "rewards":
            $("#rewardsButt").hide()
            $("#rewardsPage").fadeIn(250)
            break;
        case "withdraw":
            $("#withdrawMenu").fadeIn(250)
            break;
        case "deposit":
            $("#depositMenu").fadeIn(250)
            break;
        case "transfer":
            $("#transferMenu").fadeIn(250)
            break;
        case "home":
            closeMenu("hub")
            $("#mainUI").fadeIn(250)
            $("#homePage").fadeIn(250)
            $("#homebutton").css("background-color", "rgb(130, 178, 245, 0.5)");
            break;
        case "hub":
            closeMenu("home")
            $("#mainUI").fadeIn(250)
            $("#hubPage").fadeIn(250)
            $("#rewardsButton").fadeIn(250)
            $("#hubbutton").css("background-color", "rgb(130, 178, 245, 0.5)");
            break;
        case "welcome":
            $("#container").fadeIn(750);
            $("#welcomePage").fadeIn(500);
            break;
        case "pin":
            $("#pinPage").slideDown(250)
            $("#continue2").show()
            break;
        case "register":
            $("#welcomePage").hide()
            $("#continue").hide()
            $("#registerPage").fadeIn(250)
            var random = Math.floor((Math.random() * 99999) + 1000);
            cod = random
            isInRegisterMenu = true

            $.post('http://nfr_revolut/cod', JSON.stringify({
                cod
            }));
            break;
        default:
            break;
    }
}

function closeMenu(menuName) {
    switch (menuName) {
        case "home":
            $("#homePage").hide()

            $("#homebutton").css("background-color", "");
            break;
        case "hub":
            $("#hubPage").hide()
            $("#rewardsButton").hide()
            $("#hubbutton").css("background-color", "");
            break;
        case "rewards":
            $("#rewardsButt").fadeIn(250)
            $("#rewardsPage").hide()
            break;    
        default:
            break;
    }
}

function closeSecondaryMenu() {
    $( ".input1" ).val( "" )
    $( ".input2" ).val( "" )
    $( ".input3" ).val( "" )
    $("#mainUI").fadeOut(250);
    $("#profilePage").fadeOut(250);
    $("#homePage").fadeOut(250)
    $("#hubPage").fadeOut(250)
    closeRewardsPage()
    $("#registerPage").fadeOut(250)
    $("#pinPage").fadeOut(250)
    $("#continue").fadeOut(250)
    $("#continue2").fadeOut(250)

}
function closePopups(){
    $( ".input1" ).val( "" )
    $( ".input2" ).val( "" )
    $( ".input3" ).val( "" )
    $( ".input4" ).val( "" )
    $("#withdrawMenu").fadeOut(250)
    $("#depositMenu").fadeOut(250)
    $("#transferMenu").fadeOut(250)
}
function closeThirdMenu(){
    $("#welcomePage").hide()
    $("#registerPage").hide()
    $("#continue").hide()
    $("#continue2").hide()
    $("#pinPage").hide()

}
function closeRewardsPage(){
    $("#rewardsButt").fadeIn(250)
    $("#rewardsPage").hide()
}

function handleAction(data) {
    $.post('http://nfr_revolut/action', JSON.stringify({
        data
    }));
}
document.onkeyup = function(data) {
    if (data.which == 27) {
        $.post("http://nfr_revolut/exit", JSON.stringify({}));
        return
    }
};
function showPin() {
    var x = document.getElementById("codePin");
    if (x.type === "password") {
      x.type = "text";
    } else {
      x.type = "password";
    }
  }
  function showPin2() {
    var x = document.getElementById("pinChanged");
    if (x.type === "password") {
      x.type = "text";
    } else {
      x.type = "password";
    }
  }

$(document).click(function(event) {
    if (!isInMenu) return
    switch (event.target.id) {
        case "profileButton":
            openSecondaryMenu("profile")
            $.post("http://nfr_revolut/updateProfilePage", JSON.stringify({}));
            break;
        case "profilePageBack":
            $("#pinChangeTab").hide()
            $("#pinChanged").val("")
            $("#profilePage").hide()
            openSecondaryMenu("home")
            break;
        case "themeChange":
            if ($(".container").css('background-color') == 'rgb(255, 255, 255)') {
                let color = "rgb(50, 50, 60)"
                let textcolor = "rgb(255, 255, 255)"
                $.post('http://nfr_revolut/updateTheme', JSON.stringify({
                    color, textcolor
                }));
                $('.container').css('background-color','rgb(50, 50, 60)');
                $('.theme').css('color','rgb(255, 255, 255)');
              } else {
                let color = "rgb(255, 255, 255)"
                let textcolor = "rgb(109, 109, 109)"
                $.post('http://nfr_revolut/updateTheme', JSON.stringify({
                    color, textcolor
                }));
                $('.container').css('background-color','rgb(255, 255, 255)');
                $('.theme').css('color','rgb(109, 109, 109)');
              }
              $("#profilePage").hide()
              openSecondaryMenu("home")
            break;
        case "changepin":
            let newPin = $("#pinChanged").val()
            if(newPin.length === 4){
                $.post('http://nfr_revolut/updatePin', JSON.stringify({
                    newPin
                }));
                $("#pinChangeTab").hide()
                $("#pinChanged").val("")
                $("#profilePage").hide()
                openSecondaryMenu("home")
            } else{
                $('.inputpinChange').addClass("animated shake");
                $(".inputpinChange").css("background-color", "rgba(237, 138, 138, 0.4)");
                setTimeout(function() {
                    $('.inputpinChange').removeClass('animated shake');
                    $(".inputpinChange").css("background-color", "#EDEEF0");
                }, 500)
            }
            break;
        case "pinChange":
            $("#pinChangeTab").fadeIn(250)
            break;
        case "backButtonChangePin":
            $("#pinChanged").val("")
            $("#pinChangeTab").fadeOut(250)
            break;
        case "reward1Button":
            var data = {}
            data.price = 5
            data.reward = 150000
            data.action = "redeem1"
            handleAction(data)
            $.post("http://nfr_revolut/updateRewardCoins", JSON.stringify({}));
            $.post("http://nfr_revolut/updateBankBalance", JSON.stringify({}));
            closeMenu("rewards")
            break;
        case "reward2Button":
            var data = {}
            data.price = 25
            data.reward = 300000
            data.action = "redeem2"
            handleAction(data)
            $.post("http://nfr_revolut/updateRewardCoins", JSON.stringify({}));
            $.post("http://nfr_revolut/updateBankBalance", JSON.stringify({}));
            closeMenu("rewards")
            break;
        case "reward3Button":
            var data = {}
            data.price = 50
            data.reward = "bmci"
            data.action = "redeem3"
            handleAction(data)
            $.post("http://nfr_revolut/updateRewardCoins", JSON.stringify({}));
            $.post("http://nfr_revolut/updateBankBalance", JSON.stringify({}));
            closeMenu("rewards")
            break;    
        case "rewardBackButton":
            $("#rewardsButt").fadeIn(250)
            $("#rewardsPage").hide()
            break;
        case "rewardsButton":
            $.post("http://nfr_revolut/updateRewardCoins", JSON.stringify({}));
            openSecondaryMenu("rewards")
            break;
        case "homebutton":
            openSecondaryMenu("home")
            break;
        case "hubbutton":
            openSecondaryMenu("hub")
            break;
        case "backButtonSecondaryMenu":
            closePopups()
            break;
        case "INREGISTRARE":
            let RandomCodes = $("#code").val()
            let pinCode = $("#pin").val()
            if(RandomCodes == cod){
                if(pinCode.length === 4){
                $.post("http://nfr_revolut/codcorrect", JSON.stringify({
                    pinCode
                }));
                isInRegisterMenu = false
                openSecondaryMenu("home")
                closeThirdMenu()
                } else{
                    $('.input6').addClass("animated shake");
                    $(".input6").css("background-color", "rgba(237, 138, 138, 0.4)");
                    setTimeout(function() {
                        $('.input6').removeClass('animated shake');
                        $(".input6").css("background-color", "#EDEEF0");
                    }, 500)
                }
            } else{
                $('.input5').addClass("animated shake");
                $(".input5").css("background-color", "rgba(237, 138, 138, 0.4)");
                setTimeout(function() {
                    $('.input5').removeClass('animated shake');
                    $(".input5").css("background-color", "#EDEEF0");
                }, 500)
            }
            break;
        case "continue":
            $.post("http://nfr_revolut/checkNumber", JSON.stringify({}));
            openSecondaryMenu("register")
            break;
        case "continue2":
            let inputValue1 = $("#codePin").val()
            if(inputValue1 == pin){
                $.post("http://nfr_revolut/updateBankBalance", JSON.stringify({}));
                openSecondaryMenu("home")
                closeThirdMenu()
                $("#codePin").val("")
            } else{
                $('.input7').addClass("animated shake");
                $(".input7").css("background-color", "rgba(237, 138, 138, 0.4)");
                setTimeout(function() {
                    $('.input7').removeClass('animated shake');
                    $(".input7").css("background-color", "#EDEEF0");
                }, 500)
            }
            break;
        case "buttonWithdraw":
            openSecondaryMenu("withdraw")
            break;
        case "buttonDeposit":
            openSecondaryMenu("deposit")
            break;
        case "buttonTransfer":
            openSecondaryMenu("transfer")
            break;
        case "withdraw":
            var data = {}
            data.amount = $("#amount2").val()
            data.action = "withdraw"
            handleAction(data)
            closePopups()
            $.post("http://nfr_revolut/updateBankBalance", JSON.stringify({}));
            break;
        case "deposit":
            var data = {}
            data.amount = $("#amount1").val()
            data.action = "deposit"
            handleAction(data)
            closePopups()
            $.post("http://nfr_revolut/updateBankBalance", JSON.stringify({}));
            break;
        case "transfer":
            var data = {}
            data.userid = $("#userID").val()
            data.amount = $("#amount3").val()
            data.action = "transfer"
            handleAction(data)
            closePopups()
            $.post("http://nfr_revolut/updateBankBalance", JSON.stringify({}));
            break;
        default:
            break;
    }
})

window.addEventListener('message', (event) => {
    var data = event.data
    if (data.type === 'ui') {
        Display(data.status)
    }  else if (data.type === 'updateBankBalance') {
        $(".container").css('background-color', data.color)
        $(".theme").css('color', data.textcolor)
        var money = Intl.NumberFormat('de-DE').format(event.data.balance)
        $("#balance").html("RON "+money)
        $("#playerName").html(event.data.playerNume)
        $("#nameRecieved").html(event.data.lastNameRecieved)
        var recievedmoney = Intl.NumberFormat('de-DE').format(event.data.lastRecievedAmount)
        $("#amountRecieved").html("+ RON "+recievedmoney)
        $("#idRecieved").html(event.data.lastIdRecieved)
        $("#nameSent").html(event.data.lastNameSent)
        var sentmoney = Intl.NumberFormat('de-DE').format(event.data.lastSentAmount)
        $("#amountSent").html("- RON "+sentmoney)
        $("#idSent").html(event.data.lastIdSent)
    } else if (data.type === 'openVerified') {
        pin = event.data.pin
        $("#nameRecieved").html(event.data.lastNameRecieved)
        var recievedmoney = Intl.NumberFormat('de-DE').format(event.data.lastRecievedAmount)
        $("#amountRecieved").html("+ RON "+recievedmoney)
        $("#idRecieved").html(event.data.lastIdRecieved)
        openSecondaryMenu("welcome")
        openSecondaryMenu("pin")
        $("#nameSent").html(event.data.lastNameSent)
        var sentmoney = Intl.NumberFormat('de-DE').format(event.data.lastSentAmount)
        $("#amountSent").html("- RON "+sentmoney)
        $("#idSent").html(event.data.lastIdSent)
    } else if (data.type === 'openRegister') {
        openSecondaryMenu("welcome")
        $("#continue").show()
    } else if (data.type === "updateRewardCoins") {
        $("#rewardCoins").html(event.data.rewardCoins +" Reward coins")
    }
    else if (data.type === "updateProfilePage") {
        $("#playerTag").html("@"+event.data.playerTag)
        $("#personName").html(event.data.playerName)
    } else if (data.type ==="openMenu"){
        openSecondaryMenu("home")
    } else if (data.type ==="updateNumber"){
        $("#phoneNumber").html("+4"+event.data.number)
    }
});
