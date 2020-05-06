import React, { Component } from 'react';
import './Footer.css'

class Footer extends Component {
    render() {
        return (
            <div class="footer">
                <p>Công Ty Pi SoftWare - Thừa Thiên Huế</p>
                <p>Địa Chỉ: 6 Lê Lợi, Vĩnh Ninh, Thành phố Huế, Thừa Thiên Huế, Việt Nam</p>
                <p>Liên Hệ: <a className="link" href="http://wearepisoftware.com/" target="_blank">wearepisoftware.com</a>
                </p>
                <p>Điện Thoại: (+84) 0905137895</p>
                <p>©Nhóm Thực Tập Sinh DHKH - learn code Web</p>
        </div>
        );
    }
}

export default Footer;