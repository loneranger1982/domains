User.create!([
  {email: "perkinscoombs@gmail.com", encrypted_password: "$2a$11$88F0hnVet097zwMuRCpP3e/8wY23pItzG582JVgsE2uxa.MCWB1mC", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2017-10-19 17:28:39", last_sign_in_at: "2017-10-19 17:28:39", current_sign_in_ip: "109.147.133.172", last_sign_in_ip: "109.147.133.172", confirmation_token: "cpCBoUEQhdix9gKFmcBq", confirmed_at: "2017-10-19 17:26:22", confirmation_sent_at: "2017-10-19 17:25:59", unconfirmed_email: nil, admin: false, username: "wes", fullname: "wes perkins"},
  {email: "martin@home189.co.uk", encrypted_password: "$2a$11$i8d3iQYmYKwNWOFsGehfc.nH6p2.s.YQMn1XDwUIVY35Unlw1lbQy", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 4, current_sign_in_at: "2017-10-20 17:00:19", last_sign_in_at: "2017-10-20 10:12:38", current_sign_in_ip: "51.9.62.8", last_sign_in_ip: "51.9.62.8", confirmation_token: "GJjjDYVMiCzx58mam8V8", confirmed_at: "2017-10-19 16:30:31", confirmation_sent_at: "2017-10-19 16:30:15", unconfirmed_email: nil, admin: true, username: nil, fullname: nil}
])
Filter.create!([
  {name: "iframe Godaddy", selector: "iframe", regex: "mcc.godaddy.com", attr: "src"},
  {name: "sedoparking Javascript", selector: "script", regex: "sedoparking.com", attr: "text"},
  {name: "Html Length", selector: "html", regex: "10", attr: "htmllength"},
  {name: "h3 error", selector: "h3", regex: "error", attr: "text"}
])
