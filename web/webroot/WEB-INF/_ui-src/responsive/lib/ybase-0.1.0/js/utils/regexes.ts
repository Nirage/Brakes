const regexes = {
    printablecharacters: '^(?!\\s*$)[a-zA-Z0-9!@#$%^&*(),."\':;\\[\\]\\|/£=+-_~{}\\s]+$',
    all: '.',
    alphanumeric: '^[A-Za-z0-9 ]*$',
    numeric: '^[0-9 ]*$',
    address: "^[a-zA-Z0-9 ,.'!-]*$",
    phone: '^[0-9+ ]*$',
    mobilephone: '^(07){1}[0-9]{9}$',
    password: '^(?=.*[A-Za-z])(?=.*[0-9])',
    email: '(^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$)',
    postcode:
      '^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]))))\\s?[0-9][A-Za-z]{2})$',
    shortpostcode:
      '^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))))$',
    postcodepostfix: '^([0-9][A-Za-z]{2})$',
    // Customer Tools
    price: '^£?\\d{0,9}(.\\d{1,2})?$',
    margin: '^[0-9 ]*%?$',
    date: '^(([0-2]\\d|[3][0-1])\\/([0]\\d|[1][0-2])\\/[2][0]\\d{2})$|^(([0-2]\\d|[3][0-1])\\/([0]\\d|[1][0-2])\\/[2][0]\\d{2}\\s([0-1]\\d|[2][0-3]))$',
    allDate: '^[0-3][0-9]/[0-3][0-9]/(?:[0-9][0-9])?[0-9][0-9]$',
    numericWithoutSpace: '^[0-9]*$'
}
export default regexes;