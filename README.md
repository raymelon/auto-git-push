# auto-git-push

A utility script to automatically commit and push to remote Git repositories

## Use cases

- A good use case is if you want to automatically update a remote repo
- Another is if you want to backup a local repo

## Use this utility script to automate the following commands in order:

1.  `git add`
2.  `git commit`
3.  `git push`

## Use auto-git-push.json to:

1.  Edit the repository local paths (`path` field per item)
2.  The automated commit message (`commit_msg` field per item)
3.  The remote name so the script knows the remote url to push the changes to (`remote` field per item)
4.  and the branch to push the changes to (`branch` field per item)

## LICENSE

> MIT License
>
> Copyright (c) 2023 Raymel Francisco
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
