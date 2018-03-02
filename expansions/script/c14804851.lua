--IDOL金曲 爱的加速器
function c14804851.initial_effect(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,14804851+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c14804851.sptg)
	e2:SetOperation(c14804851.spop)
	c:RegisterEffect(e2)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c14804851.atktg)
	e2:SetValue(c14804851.atkval)
	c:RegisterEffect(e2)
	 local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e5)
end

function c14804851.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804851.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14804851.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14804851.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c14804851.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c14804851.descon)
	e1:SetOperation(c14804851.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(14804851,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	c14804851[e:GetHandler()]=e1
end
function c14804851.spop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroupCount(c14804851.spfilter,tp,LOCATION_ONFIELD,0,nil)*200
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(val)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2,true)
	end
end
function c14804851.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c14804851.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
   ct=ct+1
   c:SetTurnCounter(ct)
	if ct==1 then
		Duel.SendtoGrave(c,REASON_RULE)
		c:ResetFlagEffect(14804851)
	end
end
function c14804851.atktg(e,c)
	return c:IsSetCard(0x4848)
end
function c14804851.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804851.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804851.filter1,c:GetControler(),LOCATION_ONFIELD,0,nil)*100
end