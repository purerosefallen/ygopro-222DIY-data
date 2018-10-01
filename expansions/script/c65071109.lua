--爱慕
function c65071109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65071109.eqtg)
	e1:SetOperation(c65071109.eqop)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c65071109.eqlimit)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c65071109.efilter)
	c:RegisterEffect(e3)
	--slimes
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65071109,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c65071109.dtg)
	e4:SetOperation(c65071109.dop)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(65071109,1))
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c65071109.ctcon)
	e5:SetTarget(c65071109.cttg)
	e5:SetOperation(c65071109.ctop)
	c:RegisterEffect(e5)
end
function c65071109.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c65071109.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

function c65071109.eqlimit(e,c)
	return c:GetControler()~=e:GetHandler():GetControler()
end

function c65071109.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and te:GetOwner()~=e:GetHandler():GetEquipTarget() 
end

function c65071109.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local qc=e:GetHandler():GetEquipTarget()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc~=qc end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,qc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,qc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65071109.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65071157,0,0x4011,1500,1500,4,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP,tp) and Duel.SelectYesNo(tp,aux.Stringid(65071109,0)) then
			local token=Duel.CreateToken(tp,65071157)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c65071109.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local num1=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,65071157)
	local num2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	return num1>num2 
end
function c65071109.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local qc=e:GetHandler():GetEquipTarget()
	if chk==0 then return qc end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,qc,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c65071109.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local qc=c:GetEquipTarget()
	if c:IsRelateToEffect(e) and qc then
		Duel.GetControl(qc,tp)
	end
end