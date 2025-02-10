let mainhud = document.getElementById("mainhud");
let hudModal = document.getElementById("hudModal");
let displayHud = false;
let lockedHud = false;
$(function() {
    $("#mainhud").children().each(function() {
        $(this).hide();
    });

    mainhud = document.getElementById("mainhud");
    window.addEventListener('message', async function(event) {
        if (event.data.action == "showhud") {
            let peacetime = event.data.peacetime;
            let street = event.data.street;
            let aop = event.data.aop;
            let priority = event.data.priority;
            handleStreet(street);
            handlePeacetime(peacetime);
            handleAop(aop);
            handlePriority(priority);
        }


        if(event.data.action == "showlock") {
            $("#doorlock").html(event.data.html);
            $("#doorlock").show()
        }

        if(event.data.action == "hidelock") {
            let lock = document.getElementById("doorlock");
            if(lock) {
                lock.style.animation = "slideOutFromRight 0.3s ease-in-out forwards"
                setTimeout(function() {
                    $("#doorlock").hide()
                    lock.style.animation = "slideInFromRight 0.3s ease-in-out forwards"
                }, 1000);
            }
        }
   
    });
});

function fixhud(set) {
    if(set?.length > 0) {
        set.forEach(elemnt => {
            let div = document.getElementById(elemnt.name);
            div.style.bottom = elemnt.bottom;
            div.style.left = elemnt.left;
        })
    } else {
        let settings = {
            ["streethud"]: [config.streetLabel.htmlCode.bottom, config.streetLabel.htmlCode.left],
            ["pthud"]: [config.peacetimeSettings.htmlCode.bottom, config.peacetimeSettings.htmlCode.left],
            ["aophud"]: [config.aopSettings.htmlCode.bottom, config.aopSettings.htmlCode.left],
            ["prhud"]: [config.prioritySettings.htmlCode.bottom, config.prioritySettings.htmlCode.left]
        }
        $("#mainhud").children().each(function() {
            let element = document.getElementById(this.id);
            if(element.id == "doorlock") return;
            element.style.bottom = settings[this.id][0];
            element.style.left = settings[this.id][1];
        });
    }
}

function handleStreet(street) {
    if (street) {
        let streethud = document.getElementById("streethud");
        if (street.enabled) {
            streethud.style.backgroundColor = "rgba(0, 0, 0, 0.5)";
            streethud.style.boxShadow = "0 2px 5px rgba(0, 0, 0, 0.5)";


            if(street.reset) {
                streethud.style.bottom = street.draw.bottom
                streethud.style.left = street.draw.left
            }

            $("#streethud").show();
            $("#streethud").html(street.html);

            makeElementMovableOnHover(streethud);
        } else {
            streethud.style.animation = `${handleHudSide("streethud") ? `slideOutFromRight` : `slideOutFromLeft`} 0.3s ease-in-out forwards`;
            setTimeout(function() {
                $("#streethud").hide();
                streethud.style.animation = `${handleHudSide("streethud") ? `slideInFromRight` : `slideInFromLeft`} 0.3s ease-in-out forwards`;
            }, 300);
        }
    }
}

function handlePeacetime(peacetimeContent) {
    if (peacetimeContent) {
        let peacetime = document.getElementById("pthud");
        if (peacetimeContent.enabled) {
            peacetime.style.backgroundColor = "rgba(0, 0, 0, 0.5)";
            peacetime.style.boxShadow = "0 2px 5px rgba(0, 0, 0, 0.5)";

            if(peacetimeContent.reset) {
                peacetime.style.bottom = peacetimeContent.draw.bottom
                peacetime.style.left = peacetimeContent.draw.left
            }

            $("#pthud").show();
            $("#pthud").html(peacetimeContent.html);

            makeElementMovableOnHover(peacetime);
        } else {
            let peacetimeHud = document.getElementById("pthud");
            peacetimeHud.style.animation = `${handleHudSide("pthud") ? `slideOutFromRight` : `slideOutFromLeft`} 0.3s ease-in-out forwards`;
            setTimeout(function() {
                $("#pthud").hide();
                peacetimeHud.style.animation = `${handleHudSide("pthud") ? `slideInFromRight` : `slideInFromLeft`} 0.3s ease-in-out forwards`;;
            }, 300);
        }
    }
}

function handleAop(aop) {
    if (aop) {
        let aopdiv = document.getElementById("aophud");
        if (aop.enabled) {
            aopdiv.style.backgroundColor = "rgba(0, 0, 0, 0.5)";
            aopdiv.style.boxShadow = "0 2px 5px rgba(0, 0, 0, 0.5)";
                        
            if(aop.reset) {
                aopdiv.style.bottom = aop.draw.bottom
                aopdiv.style.left = aop.draw.left
            }

            $("#aophud").show();
            $("#aophud").html(aop.html);

            makeElementMovableOnHover(aopdiv);
        } else {
            let aopHud = document.getElementById("aophud");
            aopHud.style.animation = `${handleHudSide("aophud") ? `slideOutFromRight` : `slideOutFromLeft`} 0.3s ease-in-out forwards`;
            setTimeout(function() {
                $("#aophud").hide();
                aopHud.style.animation = `${handleHudSide("aophud") ? `slideInFromRight` : `slideInFromLeft`} 0.3s ease-in-out forwards`;;
            }, 300);
        }
    }
}
function handlePriority(priority) {
    if (priority) {
        let prhud = document.getElementById("prhud");
        if (priority.enabled) {
            prhud.style.backgroundColor = "rgba(0, 0, 0, 0.5)";
            prhud.style.boxShadow = "0 2px 5px rgba(0, 0, 0, 0.5)";

            if(priority.reset) {
                prhud.style.bottom = priority.draw.bottom
                prhud.style.left = priority.draw.left
            }


            $("#prhud").show();
            $("#prhud").html(priority.html);

    
            makeElementMovableOnHover(prhud);

        } else {
            let priHud = document.getElementById("prhud");
            if (priHud) {
                priHud.style.animation = `${handleHudSide("prhud") ? `slideOutFromRight` : `slideOutFromLeft`} 0.3s ease-in-out forwards`;
                setTimeout(function() {
                    $("#prhud").hide();
                    priHud.style.animation = `${handleHudSide("prhud") ? `slideOutFromRight` : `slideInFromLeft`} 0.3s ease-in-out forwards`;
                }, 300);
            }
        }
    }
}

function handleHudSide(id) {
    const screenWidth = window.innerWidth;
    const elementHud = document.getElementById(id);
    const elementPosition = elementHud.getBoundingClientRect().left;

    if (elementPosition > screenWidth / 2) {
        // Closer to the right side of the screen, use right slide
        return true;
    } else {
        // Closer to the left side of the screen, use left slide
        return false;
    }

}

function showDisplayButtons(reset) {
    if(lockedHud) return;
    displayHud = !displayHud
    handleStreet({enabled: displayHud, html: `<b>${config.streetLabel.htmlCode.icon} PlaceHolder Street</b>`, draw: config.streetLabel.htmlCode, reset: reset})
    handlePeacetime({enabled: displayHud, html: `<b>${config.peacetimeSettings.htmlCode.icon} PlaceHolder Peacetime</b>`, draw: config.peacetimeSettings.htmlCode, reset: reset})
    handleAop({enabled: displayHud, html: `<b>${config.aopSettings.htmlCode.icon} PlaceHolder AOP</b>`, draw: config.aopSettings.htmlCode, reset: reset})
    handlePriority({enabled: displayHud, html: `<b>${config.prioritySettings.htmlCode.icon} PlaceHolder Priority</b>`, draw: config.prioritySettings.htmlCode, reset: reset})
}

function lockHudDisplay() {
    lockedHud = !lockedHud
    if(lockedHud) {
        $("#lockHudText").html(`Unlock HUD Postion`)
    } else {
        $("#lockHudText").html(`Lock HUD Postion`)
    }
    
    $("#mainhud").children().each(function() {
        if(this.id != "doorlock") {
            let element = document.getElementById(this.id);
            if(element.style.bottom == "" || element.style.left == "") return;
            hudSettings[this.id] = {bottom: element.style.bottom, left: element.style.left}
        }
    });
}

function resetHudButtons() {
    lockedHud = false;
    displayHud = false;
    showDisplayButtons(true);
}


function makeElementMovableOnHover(element) {
    let initialMouseX, initialMouseY;
    let initialElementX, initialElementBottom;
    let isDragging = false;
    function onMouseDown(event) {
        initialMouseX = event.clientX;
        initialMouseY = event.clientY;
        initialElementX = element.offsetLeft;
        const elementRect = element.getBoundingClientRect();
        initialElementBottom = window.innerHeight - elementRect.bottom;
        isDragging = true;
        document.addEventListener('mousemove', onMouseMove);
        document.addEventListener('mouseup', onMouseUp);
        event.preventDefault();
    }
    function onMouseMove(event) {
        if (isDragging) {
            const newLeft = initialElementX + (event.clientX - initialMouseX);
            const newBottom = initialElementBottom + (initialMouseY - event.clientY);
            if(lockedHud) return;
            element.style.left = `${newLeft}px`;
            element.style.bottom = `${newBottom}px`;
        }
    }

    function onMouseUp() {
        isDragging = false;
        document.removeEventListener('mousemove', onMouseMove);
        document.removeEventListener('mouseup', onMouseUp);
    }
    element.addEventListener('mousedown', onMouseDown);
    element.addEventListener('mouseover', () => {
        element.addEventListener('mousedown', onMouseDown);
    });
    element.addEventListener('mouseout', () => {
        element.removeEventListener('mousedown', onMouseDown);
    });
}

