$(document).ready(function(){

    function Move() {
        this.view = new View
        this.listen()
    }

    /**
     * bind
     *
     * @param selector String セレクター名
     * @param event_type String イベント型
     * @param callback callable イベント発生時に着火するイベント
     * @return void
     */
    Move.prototype.bind = function(selector, event_type, callback) {
        $(selector).on(event_type, {_this: this}, function(event) {
           //ここでの this はdomセレクター
           event.data._this[callback](this)
        })
    }

    /**
     * ajaxイベントを実行する
     * ajax 処理完了時のコールバックはビューの更新
     *
     * @param url String URL
     * @param data object 送信するデータ
     * @return void
     */
    Move.prototype.execute = function(url, data) {
        $.ajax({
            url: url,
            data: data,
            context: this
        })
        .done(function(data) {
            this.release()
            this.view.update(data)
            this.listen()
        } )
        .fail(function(data) {
            console.log(JSON.parse(data.responseText).message)
        })
    }

    /**
     * イベントリスナーを登録する
     *
     * @return void
     */
    Move.prototype.listen = function() {
        this.bind('.cell.movable, .move', 'click', 'move')
        this.bind('.cell.movable, .move', 'mouseenter mouseleave', 'toggle')
        this.bind('.pass', 'click', 'pass')
        this.bind('.reset', 'click', 'reset')
    }

    /**
     * イベントリスナーを解除する
     *
     * @return void
     */
    Move.prototype.release = function() {
        $('.cell.movable, .move').unbind('click mouseenter mouseleave')
        $('.pass').unbind('click')
        $('.reset').unbind('click')
    }

    Move.prototype.move = function(selector) {
        var index = $(selector).data('index').split('_')
        this.execute('move', {x: index[0], y: index[1]})
    }

    Move.prototype.pass = function() {
        this.execute('pass')
    }

    Move.prototype.reset = function() {
        this.execute('reset')
    }

    Move.prototype.toggle = function(selector) {
        var cell = $('.cell_' + $(selector).data('index'))
        cell.toggleClass('hover')

        var reversibles = JSON.parse(cell.find('span.reversible_cell_json').text())
        $.each (reversibles, function(key, value) {
            $('#cell_' + value).find('span').toggleClass('reversible')
        })
    }

    /**
     * View
     */
    function View() {
        this.templates
        .add('move',
            '<button class="btn btn-default move cell_<%- index %>" data-index="<%- index %>"><%- index %><span class="hidden reversible_cell_json"><%- JSON.stringify(reversibles) %></span></button>'
        )
        .add('pass',
            '<button class="btn btn-default pass">パス</button>'
        )
        .add('ended',
            '<p>ゲーム終了</p><p>白: <%- white %></p><p>黒: <%- black %></p>'
        )
    }

    /**
     * templates
     */
    View.prototype.templates = {
        compiled: {},

        templates: {},

        add: function(name, template) {
            this.templates[name] = template
            return this
        },

        render: function(template, data) {
            if (!this.compiled[template]) {
                this.compiled[template] = _.template(this.templates[template])
            }
            return this.compiled[template](data)
        },
    }

    /**
     * update
     *
     * @param data object
     * @return void
     */
    View.prototype.update = function(data) {
        this.cells(data)
        this.operator(data)
    }

    View.prototype.cells = function(data) {
        _.each(data.cells, function(cell) {
            var cell_dom = $('#cell_' + cell.index).removeClass('movable hover')
            cell_dom.find('span')
                .removeClass('white black reversible')
                .addClass(cell.color)
            if (data.moves[cell.index]) {
                cell_dom.addClass('movable')
            }
        })
    }

    View.prototype.operator = function(data) {
        var operator = $('.operator')
        operator.find('.current_turn').html(data.turn)

        var moves = operator.find('.moves')
        moves.html('')

        if (data.ended) {
            return moves.append(this.templates.render('ended', data))
        } else if (!Object.keys(data.moves).length) {
            return moves.append(this.templates.render('pass'))
        }

        for (var index in data.moves) {
            var indices = _.map(data.moves[index], function(val) { return val.index })
            moves.append(this.templates.render('move', {index: index, reversibles: indices}))
        }
    }

    new Move
});
