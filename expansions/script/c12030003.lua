--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030003
local cm=_G["c"..m]
cm.rssetcode="yatori"
function c12030003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12030003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12030003.condition)
	e1:SetTarget(c12030003.target)
	e1:SetOperation(c12030003.operation)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c12030003.condition1)
	c:RegisterEffect(e4)
	--Search or Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12030003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c12030003.distg)
	e2:SetOperation(c12030003.disop)
	c:RegisterEffect(e2)
--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12030003,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c12030003.drcon)
	e3:SetTarget(c12030003.drtg)
	e3:SetOperation(c12030003.drop)
	c:RegisterEffect(e3)
end
c12030003.halo_yatori=1
function c12030003.named_with_yatori(c)
	local m=_G["c"..c:GetCode()]
	return m and m.halo_yatori
end
function c12030003.cfilter(c)
	return c:GetSequence()<5
end
function c12030003.cfilter1(c)
	return c:GetSequence()>=5 and c:IsControler(1-tp)
end
function c12030003.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12030003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12030003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12030003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		 Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12030003.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12030003.cfilter1,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c12030003.spfilter(c,e,tp)
	return c:CheckSetCard("yatori") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12030003.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and ( c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsSummonable(true,nil) )
end
function c12030003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,3,nil,TYPE_MONSTER) then
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12030003.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.RegisterFlagEffect(tp,12030003,RESET_PHASE+PHASE_END,0,1)
	else
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12030003.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
	end 
end
function c12030003.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetFlagEffect(tp,12030003)==0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12030003.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	else 
	  if Duel.IsExistingMatchingCard(c12030003.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(12030003,3)) then 
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local g=Duel.SelectMatchingCard(tp,c12030003.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		 if g:GetCount()>0 then
		 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		 end
	  else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		 local g=Duel.SelectMatchingCard(tp,c12030003.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		 if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.Summon(tp,tc,true,nil)
		 end
	  end
	end
end
function c12030003.drcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c12030003.filter1(c)
	return c:CheckSetCard("yatori") and c:IsAbleToHand()
end
function c12030003.filter2(c)
	return c:IsSummonable(true,nil)
end
function c12030003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12030003.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if  rp==1-tp and tp==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,12030003+100,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c12030003.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12030003.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if  rp==1-tp and tp==e:GetLabel() and Duel.IsExistingMatchingCard(c12030003.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12030003,4)) then
		local tg=Duel.SelectMatchingCard(tp,c12030003.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if tg:GetCount()>0 then
		   Duel.SendtoHand(tg,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,tg)
		   local hg=Duel.SelectMatchingCard(tp,c12030003.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				 if hg:GetCount()>0 then
				 local tc=hg:GetFirst()
				 Duel.Summon(tp,tc,true,nil)
				 end
		end
	 end  
end