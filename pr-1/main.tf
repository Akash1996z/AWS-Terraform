provider "aws" {
   region   = "us-east-2"
}
#======================================================== P

resource "aws_iam_user_group_membership" "m1" {
  user = aws_iam_user.user_1.name

  groups = [
    aws_iam_group.Devs.name,
  ]
}


resource "aws_iam_user_group_membership" "m2" {
  user = aws_iam_user.user_2.name

  groups = [
    aws_iam_group.Adminss.name,
  ]
}
#========================================================= M
resource "aws_iam_group" "Devs" {
  name = "Devs"
}

resource "aws_iam_group" "Adminss" {
  name = "Adminss"
}
#======================================================= Groups
resource "aws_iam_user" "user_1" {
  name = "user_1"
}

#+++++++++++++++++++++++++++++++++++++++++++

resource "aws_iam_user" "user_2" {
  name = "user_2"
}
#===================================================== Users

