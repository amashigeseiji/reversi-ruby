$(document).ready(function(){

    function Move() {
        this.view = new View
        this.data = {}
        this.execute('index')
        this.bind('.reset', 'click', 'reset')
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
    Move.prototype.execute = function(url, data, context) {
        return $.ajax({
            url: url,
            data: data,
            context: context || this
        })
        .done(function(data) {
            this.release()
            this.data = data
            this.view.update(data)
            if (!data.ended && data.turn == 'white') {
                //再帰呼び出しの中で this が変化するので
                //外部から context を指定する
                setTimeout(this.execute, 500, 'ai', {}, this)
            } else {
                this.listen()
            }
        })
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
    }

    /**
     * イベントリスナーを解除する
     *
     * @return void
     */
    Move.prototype.release = function() {
        $('.cell.movable, .move').unbind('click mouseenter mouseleave')
        $('.pass').unbind('click')
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
        var index = $(selector).data('index')
        $('.cell_' + index).toggleClass('hover')

        $.each (this.data.moves[index], function(key, cell) {
            $('#cell_' + cell.index + ' > span.disc').toggleClass('reversible')
        })
    }

    /**
     * View
     */
    function View() {
        this.templates
        .add('move',
            '<button class="btn btn-default move cell_<%- index %>" data-index="<%- index %>"><%- index %></button>'
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
            moves.append(this.templates.render('move', {index: index}))
        }
    }

    new Move
});
