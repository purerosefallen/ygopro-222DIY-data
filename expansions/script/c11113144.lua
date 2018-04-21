--乌洛波洛斯 躯干部A
function c11113144.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11113144.matfilter,2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113144,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c11113144.spcon)
	e1:SetTarget(c11113144.sptg)
	e1:SetOperation(c11113144.spop)
	c:RegisterEffect(e1)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,11113142))
	e3:SetCondition(c11113144.atkcon)
	e3:SetValue(c11113144.atkval)
	c:RegisterEffect(e3)
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c11113144.tgcon)
	c:RegisterEffect(e6)
	--damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(11113144,2))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c11113144.damcon)
	e7:SetTarget(c11113144.damtg)
	e7:SetOperation(c11113144.damop)
	c:RegisterEffect(e7)
end
function c11113144.matfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkAbove(4)
end
function c11113144.spfilter1(c,e,tp)
	return c:IsCode(11113145) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c11113144.lkfilter(c,e,tp)
	return c:IsCode(11113143) and c:IsType(TYPE_LINK) 
	    and Duel.IsExistingMatchingCard(c11113144.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLinkedZone(1-tp))
end
function c11113144.spfilter2(c,e,tp,zone)
	return c:IsCode(11113150) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone)
end
function c11113144.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11113144.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11113144.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
	if Duel.IsExistingMatchingCard(c11113144.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local g1=Duel.SelectMatchingCard(tp,c11113144.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	    if g1:GetCount()>0 and Duel.SpecialSummon(g1,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
           and Duel.GetLocationCountFromEx(1-tp)>0	
		   and Duel.IsExistingMatchingCard(c11113144.lkfilter,tp,0,LOCATION_MZONE,1,nil,e,tp)
           and Duel.SelectYesNo(tp,aux.Stringid(11113144,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11113144,3))
			local lg=Duel.SelectMatchingCard(tp,c11113144.lkfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
			Duel.HintSelection(lg)
			local zone=lg:GetFirst():GetLinkedZone(1-tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	        local g2=Duel.SelectMatchingCard(tp,c11113144.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
			if g2:GetCount()>0 then
			    Duel.SpecialSummon(g2,0,tp,1-tp,false,false,POS_FACEUP,zone)
			end
		end
	end
end
function c11113144.cfilter(c)
	return c:IsFaceup() and c:IsCode(11113142)
end
function c11113144.tgcon(e)
	return not Duel.IsExistingMatchingCard(c11113144.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c11113144.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c11113144.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function c11113144.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c11113144.atkcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c11113144.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15d) and c:IsType(TYPE_LINK)
end
function c11113144.atkval(e,c)
	return Duel.GetMatchingGroupCount(c11113144.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*500
end