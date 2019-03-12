function Git-Whoami {
    $author = git config user.name
    $email = git config user.email
    
    [pscustomobject]@{
        Author = $author
        Email = $email
    }
}