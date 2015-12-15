$(document).ready(function(){

    function Move() { this.init(); }

    Move.prototype.init = function() {
        this.template = {
            movable: $('.movable'),
            move:    $('.move'),
            pass:    $('button.pass')
        }

        this.bind(this.template.movable, 'click', 'execute')
        this.bind(this.template.move,    'click', 'execute')
        this.bind(this.template.movable, 'mouseenter mouseleave', 'toggle')
        this.bind(this.template.move,    'mouseenter mouseleave', 'toggle')
        this.bind(this.template.pass,    'click', 'pass')
    }

    Move.prototype.bind = function(dom, event_name, callback) {
        dom.on(event_name, {self: this}, function(event) {
           //ここでの this はdomセレクター
           event.data.self[callback](this);
        })
    }

    Move.prototype.execute = function(selector) {
        var index = $(selector).data('index').split('_')
        location.href = '/move?x=' + index[0] + '&y=' + index[1];
    }

    Move.prototype.pass = function() {
        location.href = '/pass';
    }

    Move.prototype.toggle = function(selector) {
        var cell = $('.cell_' + $(selector).data('index'))
        cell.toggleClass('hover')

        var reversibles = JSON.parse(cell.find('span.reversible_cell_json').text())
        $.each (reversibles, function(key, value) {
            $('#cell_' + value).find('span').toggleClass('reversible')
        })
    }

    new Move
});
