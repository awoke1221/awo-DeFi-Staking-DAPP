import Link from 'next/link';
import Image from 'next/image'


const navlinks = ["Home", 'Buy','Price', 'Sell'];

export default function Footer() {
    return (
        <div className='w-full absolute  text-[#F7ECE1] z-10'>
            <footer className="bg-[#1012124D] grid justify-stretch gap-9 w-full px-4 py-8 md:px-6 md:py-[50px] xl:px-10">
                <div className="flex justify-center gap-4">

                    <Link href="/markets" className="flex items-center gap-4">
                        <img src="/images/Logo.png" alt="Logo" className='h-[70px]' />
                    </Link>
                </div>

                <hr className='w-full' />

                <div className=' grid grid-cols-2 justify-items-start md:justify-items-center gap-y-8 md:gap-y-20 md:max-xl:gap-x-20 xl:flex xl:justify-between text-[20px] xl:px-[178.5px]'>
                    <div className='flex flex-col'>
                        <b className='pb-4 md:pb-4 font-travel-bold'>App</b>
                        <hr className='w-[60px] pb-6' />

                        <div className='grid md:grid-cols-2 gap-y-4 md:gap-y-6'>
                            {
                                navlinks.map((links, idx) =>
                                    <Link key={idx} href={links === 'Home' ? '/' : links.toLowerCase()} className="ml-2">{links}</Link>
                                )
                            }
                        </div>
                    </div>

                    <div className='flex flex-col max-md:justify-self-end'>
                        <b className='pb-4 md:pb-4 font-travel-bold'>Docs</b>
                        <hr className='w-[60px] pb-6' />

                        <div className='grid gap-y-4 md:gap-y-6'>
                            <a href='#' target='_blank'>Documents</a>
                            <a href='#' target='_blank'>GitHub</a>
                        </div>
                    </div>

                    <div className='flex flex-col'>
                        <b className='pb-4 md:pb-4 font-travel-bold'>Community</b>
                        <hr className='w-[60px] pb-6' />

                        <div className='grid gap-y-4 md:gap-y-6'>
                            <a href='#' target='_blank'>Discord</a>
                            <a href='#' target='_blank'>Telegram</a>
                        </div>
                    </div>

                    <div className='flex flex-col max-md:justify-self-end'>
                        <b className='pb-4 md:pb-4 font-travel-bold'>Social</b>
                        <hr className='w-[60px] pb-6' />

                        <div className='grid gap-y-4 md:gap-y-6'>
                            <a href='#' target='_blank'>Twitter</a>
                        </div>
                    </div>
                </div>

                <hr className='w-full' />

                <p className='!opacity-50 text-center text-[14px]'>&copy; All Rights Reserved</p>

            </footer>
        </div>
    );
}