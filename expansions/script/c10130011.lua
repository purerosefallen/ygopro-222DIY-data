--应急核心
function c10130011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10130011,5))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10130011.target)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130011,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,10130011)
	e2:SetCost(c10130011.spcost)
	e2:SetTarget(c10130011.sptg)
	e2:SetOperation(c10130011.spop)
	c:RegisterEffect(e2)   
	--NNNOOOOOP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10130011,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMING_BATTLE_PHASE)
	e3:SetCountLimit(1)
	e3:SetCost(c10130011.ddrcost)
	e3:SetTarget(c10130011.ddrtg)
	e3:SetOperation(c10130011.ddrop)
	c:RegisterEffect(e3)   
end
function c10130011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=c10130011.spcost(e,tp,eg,ep,ev,re,r,rp,0) and c10130011.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c10130011.ddrcost(e,tp,eg,ep,ev,re,r,rp,0) and c10130011.ddrtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local opt=0
		if b1 and b2 then
			opt=Duel.SelectOption(tp,aux.Stringid(10130011,0),aux.Stringid(10130011,1))
		elseif b1 then
			opt=Duel.SelectOption(tp,aux.Stringid(10130011,0))
		else
			opt=Duel.SelectOption(tp,aux.Stringid(10130011,1))+1
		end
		if opt==0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			e:SetOperation(c10130011.spop)
			c10130011.spcost(e,tp,eg,ep,ev,re,r,rp,1)
			c10130011.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(CATEGORY_RECOVER)
			e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e:SetOperation(c10130011.ddrop)
			c10130011.ddrtg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c10130011.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa336) and c:IsDiscardable() and Duel.IsExistingMatchingCard(c10130011.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c10130011.spfilter(c,e,tp)
	return c:IsSetCard(0xa336) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c10130011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10130011)==0 and Duel.IsExistingMatchingCard(c10130011.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.RegisterFlagEffect(tp,10130011,RESET_PHASE+PHASE_END,0,1)
	Duel.DiscardHand(tp,c10130011.cfilter,1,1,REASON_COST+REASON_DISCARD,nil,e,tp)
end
function c10130011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10130011.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10130011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc,ct=Duel.SelectMatchingCard(tp,c10130011.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst(),0
	if tc then
	   if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) or not Duel.SelectYesNo(tp,aux.Stringid(10130011,2))) then
		  ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	   else
		  ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		  if ct>0 then Duel.ConfirmCards(1-tp,tc) end
	   end
	   local sg=Duel.GetMatchingGroup(c10130011.ssfilter,tp,LOCATION_MZONE,0,nil)
	   if ct~=0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10130011,7)) then
		  Duel.BreakEffect()
		  Duel.ShuffleSetCard(sg)
	   end
	end
end
function c10130011.ddrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10130011)==0 end
	e:GetHandler():RegisterFlagEffect(10130011,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10130011.ddrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10130011.ddrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local op=Duel.SelectOption(tp,aux.Stringid(10130011,3),aux.Stringid(10130011,4),aux.Stringid(10130011,5))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	if op==0 then
		e1:SetDescription(aux.Stringid(10130011,3))
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	elseif op==1 then
		e1:SetDescription(aux.Stringid(10130011,4))
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		tc:RegisterEffect(e1)
	else
		e1:SetDescription(aux.Stringid(10130011,5))
		e1:SetCode(EFFECT_CANNOT_TO_DECK)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_TO_HAND)
		tc:RegisterEffect(e2)
	end
end
function c10130011.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end