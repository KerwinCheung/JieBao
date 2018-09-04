# -*- coding: utf-8 -*-
import subprocess

def status():
    archiveCmd = 'git status'
    process = subprocess.Popen(archiveCmd,shell=True)
    process.wait()
    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print "查看工作区状态错误"
    else:
        add()
    
    return True

def add():
    archiveCmd = 'git add --all'
    process = subprocess.Popen(archiveCmd,shell=True)
    process.wait()
    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print "添加到缓存区错误"
    else:
        commit()

def commit():
    inputNote = raw_input("请输入提交内容:").decode('utf-8')
    archiveCmd = "git commit -m ' " + inputNote + "'"
    process = subprocess.Popen(archiveCmd,shell=True)
    process.wait()
    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print "提交失败"
        pull()
    else:
        print "提交成功",inputNote
        pull()

def pull():
    archiveCmd = 'git pull'
    process = subprocess.Popen(archiveCmd,shell=True)
    process.wait()
    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print "拉取远程代码失败"
    else:
        push()

def push():
    archiveCmd = 'git push'
    process = subprocess.Popen(archiveCmd,shell=True)
    process.wait()
    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print "上传远程git服务器失败"
    else:
        print "上传成功"

def main():
    status()

if __name__ == '__main__':
    main()
