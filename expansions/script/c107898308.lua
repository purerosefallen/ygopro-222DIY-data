--
function c107898308.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c107898308.spcon)
	e0:SetOperation(c107898308.spop)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898308,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetTarget(c107898308.atktg)
	e1:SetOperation(c107898308.atkop)
	c:RegisterEffect(e1)
	--base atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c107898308.defval)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(107898308,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetTarget(c107898308.tgtg)
	e3:SetOperation(c107898308.tgop)
	c:RegisterEffect(e3)
end
function c107898308.cfilter(c)
	return c:IsFaceup() and c:IsCode(107898101)
end
function c107898308.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local clv=math.floor(c:GetLevel()/2)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c107898308.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and (lv==1 or Duel.IsCanRemoveCounter(tp,1,0,0x1,clv,REASON_COST))
end
function c107898308.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if c:GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(c:GetLevel()/2),REASON_COST)
	end
end
function c107898308.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898308.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898308.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c107898308.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898308.atkop(e,tp,eg,ep,ev,re,r,rp)
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
function c107898308.deffilter(c)
	return c:IsFaceup() and c:IsDefensePos() and c:IsSetCard(0x575) and c:IsType(TYPE_TOKEN)
end
function c107898308.defval(e,c)
	local g=Duel.GetMatchingGroup(c107898308.deffilter,c:GetControler(),LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetDefense)
end
function c107898308.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c107898308.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end