$('document').ready(function() {

    $('.overlay').hide();

    window.addEventListener('message', function(event) {
        if (event.data.action == 'open') {
            $('.overlay').show();
        } else if (event.data.action == 'close') {
            $('.overlay').hide();
            clearDocument()
            $.post('http://t0sic_inventoryui/NUIFocusOff', JSON.stringify({}));
        }

        
        function test(){
            let test = event.data.items
            let test1 = []
            if (test != undefined) {
                for (let i = 1; i < 50 ; i++) {
                test1.push(test[i])
                }
            }
            test1.forEach(function(item) {
                $('.item-inner').append(`<div class="${item[0]} default" id="${item[0]}"><div>`);
                $(`#${item[0]}`).html(item[1])
                $(`#${item[0]}`).css({
                    'padding': '1px',
                    'color': 'white',
                    'height': '15%',
                    'width': '15%',
                    'float': 'left',
                    'background-position': 'center',
                    'background-color': 'rgb(31, 30, 43)',
                    'box-shadow:': '11px 15px 13px 0px rgba(0,0,0,0.75)',
                    'border-radius': '5px',
                    'border': 'rgb(0, 230, 247) solid 1px',
                    'margin': '1%'
                })
            })
            test1 = []
        }
        test()
        document.getElementById('cash').innerHTML = event.data.wallet
        document.getElementById('blackmoney').innerHTML = event.data.black_money
        document.getElementById('bank').innerHTML = event.data.bank
        document.getElementById('job').innerHTML = event.data.label
    });
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $('.overlay').hide();
            clearDocument()
            $.post('http://t0sic_inventoryui/NUIFocusOff', JSON.stringify({}));
        }
      }
    var containers = dragula([
        document.getElementById('drag1'),
        document.getElementById('drag2'), 
    ]) 
    containers.on('drop',function(el,target,source,sibling){
        if (source.id == 'drag1' && source.id != target.id) {
            
            $('#drag2').each(function() {
                let count = $(this).children(`.${el.id}`).length;
                if (count > 1) {
                    $(`.${el.id}`)[0].innerHTML = Number($(`.${el.id}`)[0].innerHTML) + Number($(`.${el.id}`)[1].innerHTML)
                    $(`.${el.id}`)[1].remove()
                }
            })
        } else if (source.id == 'drag2' && source.id != target.id) {
            $.post('http://t0sic_inventoryui/drop', JSON.stringify({
                count: Number(el.innerHTML),
                item: el.id
            }));
            $(`#${el.id}`).css('background-color', 'rgb(31, 30, 43)');
            $(`#${el.id}`).removeClass('selected')
            $(`#${el.id}`).hide()
        }
    });
    containers.on('cancel', function(el, container, source){
        if(container.id == 'drag2') {
        var selectedItem = el.id
        $('#drag2').children().css('background-color', 'rgb(31, 30, 43)');
        $('#drag2').children().removeClass('selected');
        $('#money').removeClass('selected');
        $('#money').css('background-color', 'rgb(31, 30, 43)');
        $('#blackcash').removeClass('selected');
        $('#blackcash').css('background-color', 'rgb(31, 30, 43)');
        $(`#${selectedItem}`).addClass('selected');
        $(`#${selectedItem}`).css('background-color', '#1d3459');
        }
    });

    document.getElementById('money').addEventListener('click', function(event) {
        $('#drag2').children().css('background-color', 'rgb(31, 30, 43)');
        $('#drag2').children().removeClass('selected')
        $(`#blackcash`).removeClass('selected');
        $(`#blackcash`).css('background-color', 'rgb(31, 30, 43)');
        $(`#money`).addClass('selected');
        $(`#money`).css('background-color', '#1d3459');
    })

    document.getElementById('blackcash').addEventListener('click', function(event) {
        $('#drag2').children().css('background-color', 'rgb(31, 30, 43)');
        $('#drag2').children().removeClass('selected')
        $(`#money`).removeClass('selected');
        $(`#money`).css('background-color', 'rgb(31, 30, 43)');
        $(`#blackcash`).addClass('selected');
        $(`#blackcash`).css('background-color', '#1d3459');
    })

    document.getElementById('button-use').addEventListener('click', function(event) {
        var itemSelected = document.getElementsByClassName('selected')[0].id;
        $.post('http://t0sic_inventoryui/use', JSON.stringify({
                item: itemSelected
            }));
    })
    document.getElementById("button").addEventListener("click", function(event) {
        var itemSelected = document.getElementsByClassName('selected')[0];
        if (document.getElementsByClassName('selected')[0].id == 'money') {
            let amount = Number(document.getElementById('drop-count').value)
            $.post('http://t0sic_inventoryui/dropcash', JSON.stringify({
                count: amount
            }));
        } else if (document.getElementsByClassName('selected')[0].id == 'blackcash') {
            let amount2 = Number(document.getElementById('drop-count').value)
            $.post('http://t0sic_inventoryui/dropblackcash', JSON.stringify({
                count: amount2
            }));
        } else if (Number(document.getElementById('drop-count').value) > document.getElementsByClassName('selected')[0].innerText) {
            console.log(`You don't have that many ${document.getElementsByClassName('selected')[0].id}('s)`);
        } else if(Number(document.getElementById('drop-count').value) > 0) {
            $.post('http://t0sic_inventoryui/drop', JSON.stringify({
                item: document.getElementsByClassName('selected')[0].id,
                count: Number(document.getElementById('drop-count').value)
            }));
            document.getElementById(`${document.getElementsByClassName('selected')[0].id}`).innerHTML = document.getElementsByClassName('selected')[0].innerText - document.getElementById('drop-count').value;
            if (document.getElementsByClassName('selected')[0].innerHTML == 0) {
                itemSelected.style.display = 'none'
            }
        }
    });
    function clearDocument() {    	
        $("#drag1").empty();
        $("#drag2").empty();
    }
});