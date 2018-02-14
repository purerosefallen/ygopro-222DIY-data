--IDOL 闹闹
function c14804803.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804803),LOCATION_MZONE)
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c14804803.regcon)
	e1:SetOperation(c14804803.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c14804803.con1)
	e2:SetTarget(c14804803.target1)
	e2:SetOperation(c14804803.operation1)
	c:RegisterEffect(e2)
end
function c14804803.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) 
end
function c14804803.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14804803.cfilter,1,nil,1-tp)
end
function c14804803.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,200)
end
function c14804803.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c14804803.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c14804803.matfilter(c)
	return c:IsSetCard(0x4848)
end
function c14804803.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial():Filter(c14804803.matfilter,nil)
	if g:GetCount()>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c14804803.atktg)
		e1:SetValue(c14804803.atkval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14804801,1))
	end
	if g:GetCount()>=2 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(14804803,0))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(c14804803.sptg) 
		e2:SetOperation(c14804803.spop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14804801,2))
	end
end

function c14804803.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804803.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804803.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804803.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-100
end

function c14804803.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x4848) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14804803.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsPlayerCanDraw(1-tp,1)
		and Duel.IsExistingMatchingCard(c14804803.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c14804803.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14804803.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end