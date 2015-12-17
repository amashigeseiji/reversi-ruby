$(document).ready(function(){

    function Move() { this.init(); }

    Move.prototype.init = function() {
        this.template = {
            movable: '.cell.movable',
            move:    '.move',
            pass:    'button.pass'
        }

        this.bind(this.template.movable, 'click', 'execute')
        this.bind(this.template.move,    'click', 'execute')
        this.bind(this.template.movable, 'mouseenter mouseleave', 'toggle')
        this.bind(this.template.move,    'mouseenter mouseleave', 'toggle')
        this.bind(this.template.pass,    'click', 'pass')
    }

    Move.prototype.bind = function(selector, event_name, callback) {
        $(selector).on(event_name, {self: this}, function(event) {
           //ここでの this はdomセレクター
           event.data.self[callback](this);
        })
    }

    Move.prototype.unbind = function(selector, event_type) {
        $(selector).unbind(event_type)
    }

    Move.prototype.cells = {
        set: function(cells) {
            this.cells = cells
        },
        row: function(y) {
            return _.select(this.cells, function(cell) {
                    return cell.y == y
            });
        }
    };

    Move.prototype.execute = function(selector) {
        var index = $(selector).data('index').split('_')
        $.ajax({
                url: '/move',
                data: {x: index[0], y: index[1]},
                context: this
        })
        .done(function(data) {
                this.unbind(this.template.movable)
                this.unbind(this.template.move)

                data.cells.forEach(function(cell) {
                        var cell_dom = $('#cell_' + cell.index)
                        var disc = cell_dom.find('span');
                        if (disc.hasClass('black') || disc.hasClass('white')) {
                            disc.removeClass('white').removeClass('black').removeClass('reversible').removeClass('hover')
                        }
                        disc.addClass(cell.color)
                        cell_dom.removeClass('movable')
                        if (data.moves[cell.index]) {
                            cell_dom.addClass('movable')
                        }
                });

                var operator = $('.operator');
                operator.find('.current_turn').html(data.turn)
                operator.find('.moves').html('')
                var move_template = '<button class="btn btn-default move cell_{{ index }}" data-index="{{index}}">{{ index }}<span class="hidden reversible_cell_json">{{reversibles}}</span></button>'
                var compiled = _.template(move_template)

                for (var index in data.moves) {
                    var indices = _.map(data.moves[index], function(val) {
                            return val.index
                    })
                    operator.find('.moves').append(
                        compiled({index: index, reversibles: JSON.stringify(indices)})
                    )
                }

                this.bind(this.template.movable, 'click', 'execute')
                this.bind(this.template.move,    'click', 'execute')
                this.bind(this.template.movable, 'mouseenter mouseleave', 'toggle')
                this.bind(this.template.move,    'mouseenter mouseleave', 'toggle')
        })
        .fail(function(data) {
                console.log(JSON.parse(data.responseText))
        })
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
