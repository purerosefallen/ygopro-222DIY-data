--星罗妖精
function c79131363.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79131363,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,79131363)
	e1:SetCondition(c79131363.pcon)
	e1:SetTarget(c79131363.ptg)
	e1:SetOperation(c79131363.pop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,79131364)
	e2:SetCondition(c79131363.spcon)
	c:RegisterEffect(e2)
	--syn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,79131365)
	e3:SetTarget(c79131363.sctg)
	e3:SetOperation(c79131363.scop)
	c:RegisterEffect(e3)
end
function c79131363.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x79a)
end
function c79131363.pfilter(c,e,tp)
	return c:IsSetCard(0x79a) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79131363.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79131363.pfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79131363.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Destroy(c,REASON_EFFECT)~=0 and Duel.GetLocationCountFromEx(tp)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c79131363.pfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c79131363.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x79a) and c:GetCode()~=79131363
end
function c79131363.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79131363.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c79131363.filter(c,tp)
	return c:IsSetCard(0x79a) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c79131363.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local mg=Duel.GetMatchingGroup(c79131363.filter,tp,LOCATION_EXTRA,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c,mg) and c:IsAbleToGrave()
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79131363.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c79131363.filter,tp,LOCATION_EXTRA,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local f=Duel.SendtoExtraP
		Duel.SendtoExtraP=Duel.SendtoExtraPX
		Duel.SynchroSummon(tp,sg:GetFirst(),c,mg)
		Duel.SendtoExtraP=f
	end
end
function Duel.SendtoGraveX(g,reason)
	Duel.SendtoGrave(g,POS_FACEUP,reason)
end
