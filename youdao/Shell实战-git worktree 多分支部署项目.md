## Nginx 配置泛域名

## git-worktree 自动部署分支

```shell
#!/usr/bin/bash

# 部署分支
branch=''
if [ $1 ];then
    branch=$1
fi
if [ "$branch" = "" ];then
    echo '缺乏分支名'
	exit 1
fi

# 定义项目目录
stable_path='/data/htdocs/stable_project'
# 定义部署目录
deploy_path="/data/htdocs_deploy/all_project/$branch"
#全局命令
get_current_branch='git symbolic-ref --short -q HEAD' # 获取当前分支
pull_branch='git pull $(git remote) $(git symbolic-ref --short -q HEAD) &> /dev/null' # 自动拉取当前分支

if [ ! -d "$deploy_path" ];then
    echo '分支目录不存在，创建目录 : mkdir -p '$deploy_path
	mkdir -p $deploy_path
fi

function action()
{
	local link_name
	link_name=$(echo "$1" | sed -e "s#$stable_path#$deploy_path#g") # 获取要部署目录的新文件路径
	echo -e "$1 --> $link_name :"
	# 处理软链文件
	if [ -L "$1" ];then
	    source=$(readlink $1) # 获取软链源文件路径
		# 如果软链指向的目标已经是一个软链
		if [ -e $link_name ] && [ -L $link_name ];then
			if [ "$source" = $(readlink $link_name) ];then
			    echo -e $source " 软链指向：" $link_name;
			else
			    echo -e $link_name' 已经存在,但源文件指向：' $source;
				exit 2
			fi
		else
		    echo -e $source " 软链指向：" $link_name;
		    ln -s $source $link_name
		fi
	else
		# 非初次部署-查看目标路径已经存在:①.对比目标目录的当前分支名与部署分支是否一致？
		# 一致 或 目标目录已经是一个软链 ：git pull；
		# 不一致：删除目标文件，重新部署当前目录
		if [ -e $link_name ];then
			cd $link_name
			current_branch=$(eval $get_current_branch) # 当前分支
			if [ -L $link_name ] && [ $branch = $current_branch ];then
				eval $pull_branch &&	echo "update $link_name $(eval $get_current_branch) succeeeded!" || echo "update $link_name $(eval $get_current_branch) failed!"
			else
				echo "$branch $current_branch 分支不同！$link_name"
				exit 3333
			    #unlink($link_name)
			fi
		else
    		cd $1
    	    current_branch=$(eval $get_current_branch) # 当前分支
    		# reset 当前工作域自动 fetch 远程信息
    	    git reset --hard HEAD &> /dev/null && git fetch -p $(git remote) &> /dev/null && eval $pull_branch && git worktree prune &> /dev/null && {
    			echo "update $current_branch succeeeded"
    		} || {
    			echo "update $current_branch failed"
    		}
    		
    		if [[  $current_branch != 'master' && `git branch -r | grep origin/master | wc -l` != 0 ]];then
    			# 先更新当前分支，然后切到主分支
    			echo $1 " 目录当前不是 master 分支：切换到 master"
    	        git switch master && eval $pull_branch
    		    current_branch=$(eval $get_current_branch) # 重新获取当前分支
    		fi
    
    		# 判断远程是否有部署分支
    		git branch -r | grep -P "$(git remote)/$branch\b" && {
    			echo "远程存在分支 $branch\n执行：git worktree add --track -b $branch $link_name" 
    			git worktree add --track -b $branch $link_name
    		} || {
    			echo "远程没有 $branch"
    			echo -e "当前分支: "$(git symbolic-ref --short -q HEAD)
    			if [ -L "$link_name" ];then
    				if [ "$1" = $(readlink $link_name) ]; then
    					echo "软链成功!"
    				else
    					echo $link_name"已存在，软链失败"
    					exit 4
    				fi
    			else
    				echo -e "执行 ln -s $1 $link_name"
    				ln -s $1 $link_name
    			fi
    		}
    		# 有部署分支则，git worktree add <deploy_path> --detach <branch>
    		# 无，则 ln -s $1 <deploy_path>
    
    		# 如果存在子模块，则同步更新子模块(worktree 方式是不会将子模块一并拉过来)
    	    if [ -f "$1/.gitmodules" ];then
    			echo "存在子模块"
               #git submodule update --init --remote
    	    fi
    		# 当前分支与master分支composer.json文件有差异，则需要执行composer
		fi
	fi
	echo -e "\n"
	return 0
}

function listDir()
{
    local project_path=$1;
    # 如果不是 Git 目录
    for file in `ls $project_path`;
    do
        if [ -d "$project_path/$file/.git" ] || [ -L "$project_path/$file" ];then
			local deploy
			deploy=$(echo "$project_path" | sed -e "s#$stable_path#$deploy_path#g")
			if [ ! -d $deploy ]; then
				echo -e "$deploy 不存在。 mkdir -p  $deploy\n"
				mkdir -p  $deploy
			fi
            if [ $file = "library" ];then
#                action $project_path/$file/erc-model
                echo "$project_path/$file/erc-model 没有处理！"
#				echo $project_path/$file
#				exit 333
            fi
            action $project_path/$file
        elif [ -d "$project_path/$file" ] && [ $file = "static" ];then # 前端的目录仓库，特殊处理
			action $project_path/$file/email_tmp && echo "执行完email_tmp处理" 
		elif [ -d "$project_path/$file" ];then
			listDir $project_path/$file
        fi
    done
}

listDir $stable_path
```