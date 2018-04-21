--神殿的调弦
function c22231001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22231001+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22231001.cost)
	e1:SetTarget(c22231001.target)
	e1:SetOperation(c22231001.activate)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c22231001.tg)
	e2:SetOperation(c22231001.op)
	c:RegisterEffect(e2)
end
function c22231001.IsValhalla(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Valhalla
end
function c22231001.cfilter(c)
	return c22231001.IsValhalla(c) and c:IsType(TYPE_MONSTER)
end
function c22231001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local g=Duel.GetOperatedGroup()
	if g:FilterCount(c22231001.cfilter,nil)>0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c22231001.spfilter(c,e,tp)
	return c22231001.IsValhalla(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22231001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c22231001.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	end
end
function c22231001.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if not (Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c22231001.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c22231001.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
	if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(22231001,0)) then
		Duel.Draw(tp,1,REASON_EFFECT) 
	end
end
function c22231001.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22231001.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,22231001)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,5))
	e1:SetValue(0x1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,22231001,RESET_PHASE+PHASE_END,0,1)
end