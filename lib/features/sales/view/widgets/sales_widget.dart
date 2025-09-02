import 'package:flutter/material.dart';

class SalesWidget extends StatelessWidget {
  const SalesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      // height: 80,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Karthik"),
              const SizedBox(
                width: 4,
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 151, 255, 133),
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Paid",
                    style: TextStyle(
                        color: Color.fromARGB(255, 19, 126, 5), fontSize: 12),
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text("30 Dec 2024"),
              )
            ],
          ),
          const Row(
            children: [
              Text(
                "2500",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              const Text(
                "Balance : 0",
                style: TextStyle(color: Color.fromARGB(255, 91, 91, 91)),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.share_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          ),
        ],
      ),
    );
  }
}
