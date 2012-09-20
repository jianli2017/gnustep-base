/* Implementation of QuickSort for GNUStep
   Copyright (C) 2005-2012 Free Software Foundation, Inc.

   Written by:  Saso Kiselkov <diablos@manga.sk>
   Date: 2005

   Modified by: Niels Grewe <niels.grewe@halbordnung.de>
   Date: September 2012

   This file is part of the GNUstep Base Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02111 USA.
   */

#import "common.h"
#import "Foundation/NSSortDescriptor.h"
#import "Foundation/NSArray.h"
#import "Foundation/NSObjCRuntime.h"
#import "GSSorting.h"

/// Swaps the two provided objects.
static inline void
SwapObjects(id * o1, id * o2)
{
  id temp;

  temp = *o1;
  *o1 = *o2;
  *o2 = temp;
}

/**
 * Sorts the provided object array's sortRange according to sortDescriptor.
 */
// Quicksort algorithm copied from Wikipedia :-).
#if GS_USE_QUICKSORT
static void
_GSQuickSort(id *objects,
  NSRange sortRange,
  id comparisonEntity,
  GSComparisonType type,
  void *context)
{
  if (sortRange.length > 1)
    {
      id pivot = objects[sortRange.location];
      unsigned int left = sortRange.location + 1;
      unsigned int right = NSMaxRange(sortRange);

      while (left < right)
        {
          if (GSCompareUsingDescriptorOrComparator(left, right,
	    comparisonEntity, type, context) == NSOrderedDescending)
            {
              SwapObjects(&objects[left], &objects[--right]);
            }
          else
            {
              left++;
            }
        }

      SwapObjects(&objects[--left], &objects[sortRange.location]);
      SortObjectsWithDescriptor(objects, NSMakeRange(sortRange.location, left
        - sortRange.location), sortDescriptor);
      SortObjectsWithDescriptor(objects, NSMakeRange(right,
        NSMaxRange(sortRange) - right), sortDescriptor);
    }
}

@interface GSQuickSortPlaceHolder : NSObject
@end

@implementation GSQuickSortPlaceHolder
+ (void) load
{
  _GSSortUnstable = _GSQuickSort;
}
@end
#endif