--音语—灵动之竖琴
function c22600001.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c22600001.synlimit)
	c:RegisterEffect(e1)

	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22600001)
	e2:SetCondition(c22600001.spcon)
	e2:SetTarget(c22600001.sptg)
	e2:SetOperation(c22600001.spop)
	c:RegisterEffect(e2)

	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22600001,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c22600001.destg)
	e3:SetValue(c22600001.value)
	e3:SetOperation(c22600001.desop)
	c:RegisterEffect(e3)

	--banish deck
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,22600002)
	e4:SetTarget(c22600001.dktg)
	e4:SetOperation(c22600001.dkop)
	c:RegisterEffect(e4)
end

function c22600001.synlimit(e,c)
	return c:IsSetCard(0x260)
end

function c22600001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end

function c22600001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c22600001.spop(e,tp,eg,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(22600001,RESET_EVENT+0xfe0000,0,1)
		Duel.SpecialSummonComplete()
	end
end

function c22600001.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x260) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsControler(tp)
end

function c22600001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return not eg:IsContains(e:GetHandler()) and eg:IsExists(c22600001.dfilter,1,nil,tp)
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		return true
	else 
		return false 
	end
end

function c22600001.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x260) and not c:IsReason(REASON_REPLACE) and c:IsControler(e:GetHandlerPlayer())
end

function c22600001.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function c22600001.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local m=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then 
		return m>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=m
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_DECK)
end

function c22600001.dkop(e,tp,eg,ev,re,r,rp)
	local m=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetDecktopGroup(1-tp,m)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
