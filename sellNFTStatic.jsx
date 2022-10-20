import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import NFT from '../../utils/Abis/NFT7.json';
import { abi } from '../../utils/endpoints';
import { ethers } from "ethers";
import Web3Modal from "web3modal";
const NFT_TABLE = require('../../assets/img/section-image/nft-table.png');
const BLUE_TICK = require('../../assets/img/home/blue-check.png');
const { LazyMinter } = require('../../utils/web3/lazyMinter');

const SellNftModal = ({ showModal, data }) => {
  const navigate = useNavigate();
  const handelCancel = () =>{
    navigate(`/view-nft/${data?.id}`)
  } 
  const handleSign = () => {
		
  }

  const signature = async () => {
    //  let network;
    //console.log("hello workld --------------- ");
    //const [signer, setsigner] = useState('');
    // const { account, chainId } = useMetaMask();
    // if (chainId == 4) {
    // 	network = 'rinkeby'; //using for rinkeby testnet(Ethereum)
    // } else if (chainId == 80001) {
    // 	network = 'https://matic-mumbai.chainstacklabs.com/';//using for mumbai testnet(Polygon)
    // }
    // else if (chainId == 1) {
    // 	network = 'mainnet';//using for rinkeby mainnet(Ethereum)
    // }
    // else if (chainId == 137) {
    //network = 'https://rpc-mainnet.matic.network';//using for mumbai mainnet(Polygon)
    // }
    // const signer = "0xc313C73Fe894b645cC4eF36C79C78Da6763f372b";
    const web3Modal = new Web3Modal({
      network: "mumbai",
      cacheProvider: true,
    });

    const connection = await web3Modal.connect();

    const provider = new ethers.providers.Web3Provider(connection);
    
    const signer = provider.getSigner();
    console.log("signer ------------ ", signer);
    const nftaddress = "0x06453C6188Dc121B4695d5437a0F9340E11DdA45"
    let contract = new ethers.Contract(nftaddress, abi.nft7, signer);
    console.log("signer._signTypedData --------- ", signer._signTypedData);
    let lazyMinter = new LazyMinter({ contract: contract, signer: signer })
    // const balanceInEth = ethers.utils.formatEther(0.5);
    let price = ethers.utils.parseEther(data?.price);
    await lazyMinter.createVoucher(21235,
      "ipfs://bafybeigdyrzt5sfp7udmhu76uh7y26nf3efuylqabf3oclgtqy55fbzdi", price).then((voucher) => {
        console.log("voucher ============= ", voucher);
      }).catch((error) => {
        console.log("voucher error ============= ", error);
      })
  }
	return (
		<>
			<div className='' id="selling-you-item" role='document' style={{ border: 'none' }}>
				<div className=''>
					<div className='modal-body'>``
						<div className='modal-inner-area'>
							<h3>Selling your item</h3>
							<div className='sell-nft-wraaper'>
								<div className='sell-nft-box-wrap'>
									<img src={NFT_TABLE} />
									<div className='sell-nft-name'>
										<h3>Abstract Works</h3>
										<span className='second-col'>
											<a href='javascript:void(0);' tabIndex={0}>
												Creator!
											</a>{' '}
											<img src={BLUE_TICK} />
										</span>
									</div>
								</div>
								<div className='sell-nft-details'>
									<span>Price</span>
									<h3>7.0154 ETH</h3>
									<span>$20,000 USD</span>
								</div>
							</div>
							<p className='mt-2'>
								Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed
								diam lorem ipsum lemar nonumy eirmod tempor.
							</p>
							<div className='help-faq-wrapper'>
								<div className='panel-group' id='accordion'>
									<div className='panel panel-default'>
										<div className='panel-heading'>
											<h3 className='panel-title'>
												<a
													data-toggle='collapse'
													className='collapsed'
													data-parent='#accordion'
													href='#collapse3'
												>
													<span className='faq-count'>1</span>Sign
												</a>
											</h3>
										</div>
										<div id='collapse3' className='panel-collapse collapse in'>
											<div className='panel-body'>
												<p>
													Lorem ipsum dolor sit amet, consetetur sadipscing
													elitr, sed diam lorem ipsum lemar nonumy eirmod
													tempor, Lorem ipsum dolor sit amet, consetetur
													sadipscing elitr.
												</p>
												<span>Waiting for initialization…</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div className='modal-footer'>
            <div className="row">
              <div className="col-md-6">
              <div className='url-link'>
							<a
								className='btn btn-block btn-primary btn-lg font-weight-medium auth-form-btn'
								onClick={showModal}
								id='js-ready-sell-modal'
							>
								Sign
							</a>
						</div>
              </div>
              <div className="col-md-6">
              <div className='url-link'>
							<a
								className='btn btn-block btn-primary btn-lg font-weight-medium auth-form-btn'
								onClick={handelCancel}
								id='js-ready-sell-modal'
							>
								Cancel
							</a>
						</div>
              </div>
            </div>
					
        
					</div>
				</div>
			</div>
		</>
	);
};

export default SellNftModal;
