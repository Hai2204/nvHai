import React, { Component } from 'react';
import '../ViewDetail/ViewDetail1';
import '../ViewDetail/ViewDetail2';
import '../ViewDetail/ViewDetail3';
import '../ViewDetail/ViewDetail4';
import img1 from './Image-photo/1.jpg';
import img2 from './Image-photo/chaybo.png';
import img3 from './Image-photo/masoi.jpg';
import img4 from './Image-photo/6.jpg';


class Photo extends Component {
    render() {
        return (

                <div className="Container">
                    {/* học */}
                    <div className="Container_item">
                        <p id="p01">Học</p>
                        <p id="p001">Công Ty Pi software</p>
                        <p id="p0001">
                            <i class="fas fa-heart"></i>
                        </p>
                        <a href="../ViewDetail/ViewDetail2.js" alt="hoc" target="_self">
                            <img className="img1" src={img1}></img>
                        </a>
                    </div>
                    {/* chạy bộ  */}
                    <div className="Container_item">
                        <p id="p02">Chạy bộ</p>
                        <p id="p001">Công Viên 3/2 TP Huế</p>
                        <p id="p0001">
                            <i class="fas fa-heart"></i>
                        </p>
                        <a href="../ViewDetail/ViewDetail4.js" alt="chaybo" target="_self">
                            <img className="img2" src={img2}></img>
                        </a>
                    </div>
                    {/* ma soi */}
                    <div className="Container_item">
                        <p id="p03">Ma sói</p>
                        <p id="p001">Công Ty Pi software</p>
                        <p id="p0001">
                            <i class="fas fa-heart"></i>
                        </p>
                        <a href="../ViewDetail/ViewDetail3.js" alt="choi" target="_self">
                            <img className="img3" src={img3}></img>
                        </a>
                    </div>
                    {/* pic nic */}
                    <div className="Container_item">
                        <p id="p04">Picnic</p>
                        <p id="p001">Công Viên Bùi Thị Xuân</p>
                        <p id="p0001">
                            <i class="fas fa-heart"></i>
                        </p>
                        <a href="../ViewDetail/ViewDetail1.js" alt="picnic" target="_self">
                            <img className="img4" src={img4}></img>
                        </a>
                    </div>
                </div>
        );
    }
}

export default Photo;