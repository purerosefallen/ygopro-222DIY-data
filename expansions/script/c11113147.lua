--乌洛波洛斯 翼部
function c11113147.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11113147.matfilter,2,2)
	--destroy & special summon parts
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113147,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c11113147.descon)
	e1:SetTarget(c11113147.destg)
	e1:SetOperation(c11113147.desop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c11113147.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11113147.tgcon)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11113147,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c11113147.damcon)
	e4:SetTarget(c11113147.damtg)
	e4:SetOperation(c11113147.damop)
	c:RegisterEffect(e4)
end
function c11113147.matfilter(c)
	return c:IsLinkType(TYPE_NORMAL) and c:IsSetCard(0x15d)
end
function c11113147.desfilter(c)
	return not (c:IsType(TYPE_LINK) and c:IsSetCard(0x15d))
end
function c11113147.spfilter(c,e,tp,zone)
	return c:IsCode(11113149) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone)
end
function c11113147.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11113147.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lg=e:GetHandler():GetLinkedGroup():Filter(c11113147.desfilter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,lg,lg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end	
function c11113147.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
    local lg=c:GetLinkedGroup():Filter(c11113147.desfilter,nil)
	if lg:GetCount()>0 then Duel.Destroy(lg,REASON_EFFECT) end
	local seq=c:GetSequence()
	if seq<=4 or Duel.GetLocationCountFromEx(1-tp)<=0 then return end
	local zone=c:GetLinkedZone(1-tp)
	if Duel.IsExistingMatchingCard(c11113147.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) then 
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11113147.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
	    if g:GetCount()>0 then
       		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP,zone)
		end	
	end	
end
function c11113147.indtg(e,c)
	return c:GetMutualLinkedGroupCount()>0 and c:IsSetCard(0x15d) and c:IsType(TYPE_LINK)
end
function c11113147.cfilter(c)
	return c:IsFaceup() and c:IsCode(11113142)
end
function c11113147.tgcon(e)
	return not Duel.IsExistingMatchingCard(c11113147.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c11113147.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c11113147.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function c11113147.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end