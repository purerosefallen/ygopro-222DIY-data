
function c107898304.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c107898304.spcon)
	e0:SetOperation(c107898304.spop)
	c:RegisterEffect(e0)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898304,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetTarget(c107898304.target)
	e1:SetOperation(c107898304.operation)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(107898304,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(c107898304.tgtg)
	e2:SetOperation(c107898304.tgop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(107898304,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetTarget(c107898304.atktg)
	e3:SetOperation(c107898304.atkop)
	c:RegisterEffect(e3)
end
function c107898304.tdfilter(c)
	return not c:IsType(TYPE_EQUIP) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_LINK) and c:IsSetCard(0x575) and c:IsFaceup() and c:IsAbleToDeck()
end
function c107898304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler()==Duel.GetAttacker() and Duel.IsExistingMatchingCard(c107898304.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c107898304.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c107898304.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	end
end
function c107898304.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898101)
end
function c107898304.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local clv=math.floor(c:GetLevel()/2)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c107898304.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and (lv==1 or Duel.IsCanRemoveCounter(tp,1,0,0x1,clv,REASON_COST))
end
function c107898304.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if c:GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(c:GetLevel()/2),REASON_COST)
	end
end
function c107898304.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898304.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898304.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c107898304.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898304.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local atk=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end
function c107898304.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c107898304.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end