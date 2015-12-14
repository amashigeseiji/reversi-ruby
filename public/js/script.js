$(document).ready(function(){
    var movable = $('.movable');
    var move = $('.move');
    var get_index = function(selector) {
        console.log($(selector).data('index'))
        var tmp = $(selector).data('index').split('_');
        return {x: tmp[0], y: tmp[1]};
    };
    var move_url = function(index) {
        return '/move?x=' + index.x + '&y=' + index.y
    };
    var get_cell = function(index) {
        return $('#cell_' + index.x + '_' + index.y);
    };

    $.each([movable, move], function() {
        this.on('click', function() {
            location.href = move_url(get_index(this));
        });
    });

    move.hover(
        function() {
            get_cell(get_index(this))
                .css('background-color', 'rgba(200, 255, 255, 0.9)');
        },
        function() {
            get_cell(get_index(this))
                .css('background-color', '');
        }
    );

    $('button.pass').on('click', function() {
        location.href = '/pass';
    })
});
