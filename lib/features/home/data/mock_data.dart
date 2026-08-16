class BannerItem {
  final String imageUrl;

  const BannerItem({required this.imageUrl});
}

class CategoryItem {
  final String name;
  final String imageUrl;

  const CategoryItem({required this.name, required this.imageUrl});
}

const bannerImages = [
  BannerItem(
    imageUrl: 'https://wallpapercave.com/wp/wp2896922.jpg',
  ),
  BannerItem(
    imageUrl:
        'https://tse3.mm.bing.net/th/id/OIP.fA_LL-UGSiFLFSIcOacIygHaE8?r=0&w=736&h=491&rs=1&pid=ImgDetMain&o=7&rm=3',
  ),
  BannerItem(
    imageUrl:
        'https://tse1.mm.bing.net/th/id/OIP.HTPCXU0TOFrfyfqdBkHXsAHaFE?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
  ),
];

const categories = [
  CategoryItem(
    name: 'man',
    imageUrl:
        'https://tse1.explicit.bing.net/th/id/OIP.oJ8-NkXN9bPSpbZu1tY3pAHaGd?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
  ),
  CategoryItem(
    name: 'women',
    imageUrl:
        'https://tse1.mm.bing.net/th/id/OIP.OeJS1kqD7LQODDBgZ3gbBwHaE_?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
  ),
  CategoryItem(
    name: 'child',
    imageUrl:
        'https://tse2.mm.bing.net/th/id/OIP.PS4Q-q4YDJZdhTkqTEt0RgHaFk?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
  ),
];