--幻层驱动器 阻隔层
function c10130001.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(10130001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10130101)
	e1:SetTarget(c10130001.thtg)
	e1:SetOperation(c10130001.thop)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10130001)
	e2:SetCost(c10130001.setcon)
	e2:SetTarget(c10130001.settg)
	e2:SetOperation(c10130001.setop)
	c:RegisterEffect(e2) 
	c10130001.flip_effect=e1
end
function c10130001.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c10130001.setfilter(c,e,tp)
	return c:IsSetCard(0xa336) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsLevelBelow(4)
end
function c10130001.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10130001.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10130001.setfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp)
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) and sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10130001,4)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	   local g=sg:Select(tp,1,1,nil)
	   Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	   Duel.SpecialSummonComplete()
	   g:AddCard(c)
	   Duel.ConfirmCards(1-tp,g)
	   if Duel.SelectYesNo(tp,aux.Stringid(10130001,3)) then
		  Duel.BreakEffect()
		  local sg=Duel.GetMatchingGroup(c10130001.ssfilter,tp,LOCATION_MZONE,0,nil)
		  Duel.ShuffleSetCard(sg)
	   end
	end
end
function c10130001.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c10130001.thfilter(c)
	return c:IsSetCard(0xa336) and (c:IsAbleToHand() or ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()))
end
function c10130001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10130001.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10130001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10130001.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	   local tc=g:GetFirst()
	   local sset=tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable()
	   local mset=tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	   if tc:IsAbleToHand() and (not (sset or mset) or not Duel.SelectYesNo(tp,aux.Stringid(10130001,2))) then
		  Duel.SendtoHand(tc,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tc)
	   else
		  local ct=0
		  if sset then
			 ct=Duel.SSet(tp,Group.FromCards(tc))
		  else
			 ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		  end
		  Duel.ConfirmCards(1-tp,tc)
		  if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(10130001,3)) then
			 Duel.BreakEffect()
			 local sg=Duel.GetMatchingGroup(c10130001.ssfilter,tp,LOCATION_MZONE,0,nil)
			 Duel.ShuffleSetCard(sg)
		  end
	   end
	end
end