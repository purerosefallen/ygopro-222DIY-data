--ν高达
function c47530093.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3)
	c:EnableReviveLimit()	
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c47530093.atkval)
	c:RegisterEffect(e1)	
	--awake of newtype
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c47530093.incon1)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetCondition(c47530093.discon)
	e3:SetTarget(c47530093.distg)
	e3:SetOperation(c47530093.disop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c47530093.incon3)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c47530093.immtg)
	e4:SetValue(c47530093.efilter2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e5:SetCondition(c47530093.incon4)
	e5:SetTarget(c47530093.aitg)
	e5:SetOperation(c47530093.aiop)
	c:RegisterEffect(e5)
end
function c47530093.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsRace,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil,RACE_MACHINE)
	return g:GetClassCount(Card.GetAttribute)*500
end
function c47530093.incon1(e,c)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)>=2
end
function c47530093.incon3(e,c)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)>=4
end
function c47530093.incon4(e,c)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)>=8
end
function c47530093.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and Duel.IsChainDisablable(ev) and Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)>=3
end
function c47530093.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c47530093.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c47530093.immtg(e,c)
	return c~=e:GetHandler()
end
function c47530093.efilter2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c47530093.hspfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c47530093.aitg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47530093.hspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c47530093.hspfilter,1-tp,LOCATION_EXTRA,0,1,nil,e,1-tp) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function c47530093.aiop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,nil)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c47530093.hspfilter,1-tp,LOCATION_EXTRA,0,nil,e,1-tp)
		if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sg,0,1-tp,1-tp,true,false,POS_FACEUP)
		end   
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g1=Duel.GetMatchingGroup(c47530093.hspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end