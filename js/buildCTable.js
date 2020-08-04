$(document).ready(function() {
	buildCTable();
	});

function buildCTable() {
    var hs = $('#post_body').find('h1,h2,h3,h4,h5,h6');
    if (hs.length < 2)
        return;
    var s = '';
    s += '<div style="clear:both"></div>';
    s += '<div class="toc">';
    s += '<p style="text-align:right;margin:0;"><span style="float:left;">目录<a href="#" title="系统根据文章中H1到H6标签自动生成文章目录">(?)</a></span><a href="#" onclick="javascript:return openct(this);" title="展开">[+]</a></p>';
    s += '<ol style="display:none;margin-left:14px;padding-left:14px;line-height:160%;">';
    var old_h = 0, ol_cnt = 0;
    for (var i = 0; i < hs.length; i++) {
        var h = parseInt(hs[i].tagName.substr(1), 10);
        if (!old_h)
            old_h = h;
        if (h > old_h) {
            s += '<ol>';
            ol_cnt++;
        }
        else if (h < old_h && ol_cnt > 0) {
            s += '</ol>';
            ol_cnt--;
        }
        if (h == 1) {
            while (ol_cnt > 0) {
                s += '</ol>';
                ol_cnt--;
            }
        }
        old_h = h;
        var tit = hs.eq(i).text().replace(/^\d+[.、\s]+/g, '');
        tit = tit.replace(/[^a-zA-Z0-9_\-\s\u4e00-\u9fa5]+/g, '');

        if (tit.length < 100) {
            s += '<li><a href="#t' + i + '">' + tit + '</a></li>';
            hs.eq(i).html('<a name="t' + i + '"></a>' + hs.eq(i).html());
        }
    }
    while (ol_cnt > 0) {
        s += '</ol>';
        ol_cnt--;
    }
    s += '</ol></div>';
    s += '<div style="clear:both"><br></div>';
    $(s).insertBefore($('#post_body'));
}

function openct(e) {
    if (e.innerHTML == '[+]') {
        $(e).attr('title', '收起').html('[-]').parent().next().show();
    } else {
        $(e).attr('title', '展开').html('[+]').parent().next().hide();
    }
    e.blur();
    return false;
}