--乌洛波洛斯 躯干部B
function c11113145.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11113145.matfilter,2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113145,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c11113145.spcon)
	e1:SetTarget(c11113145.sptg)
	e1:SetOperation(c11113145.spop)
	c:RegisterEffect(e1)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11113145.tgcon)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11113145,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c11113145.damcon)
	e4:SetTarget(c11113145.damtg)
	e4:SetOperation(c11113145.damop)
	c:RegisterEffect(e4)
	--damage half
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c11113145.dmcon)
	e5:SetOperation(c11113145.dmop)
	c:RegisterEffect(e5)
end
function c11113145.matfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkAbove(4)
end
function c11113145.spfilter(c,e,tp)
	return c:IsCode(11113146) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c11113145.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11113145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11113145.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
	if Duel.IsExistingMatchingCard(c11113145.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local g1=Duel.SelectMatchingCard(tp,c11113145.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	    if g1:GetCount()>0 then
    	    Duel.SpecialSummon(g1,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		end
	end
end	
function c11113145.cfilter(c)
	return c:IsFaceup() and c:IsCode(11113142)
end
function c11113145.tgcon(e)
	return not Duel.IsExistingMatchingCard(c11113145.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c11113145.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c11113145.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function c11113145.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c11113145.dmcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttackTarget()
	return Duel.GetAttacker():IsCode(11113142) and a~=nil and a:IsSetCard(0x15d) and a:IsType(TYPE_LINK)
	    and e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c11113145.dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end