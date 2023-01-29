import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yummy/views/widgets/recipe_card.dart';

import '../models/recipe.api.dart';
import '../models/recipe.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Recipe> _recipes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _launchURL(String url) async{
    final Uri uri = Uri(scheme:"https",host: url);
    if(!await launchUrl(uri,mode: LaunchMode.externalApplication,)){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can not open recipe")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.restaurant_menu,color: Colors.black,),
              SizedBox(width: 10),
              Text('Food Recipe',
              style: TextStyle(color: Colors.black),)
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        _launchURL(_recipes[index].recipe);
                      },
                      child: RecipeCard(
                          title: _recipes[index].name,
                          cookTime: _recipes[index].totalTime,
                          rating: _recipes[index].rating.toString(),
                          thumbnailUrl: _recipes[index].images),
                    );
                  },
            )
    );
  }
}