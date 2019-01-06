--灵子武者-剑魔
function c21520052.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x494),4,4,21520046,aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c21520052.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e2:SetCondition(c21520052.spcon)
	e2:SetOperation(c21520052.spop)
	c:RegisterEffect(e2)
	--when special success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520052,0))
--	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
--	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c21520052.adtg)
	e3:SetOperation(c21520052.adop)
--	e3:SetValue(c21520052.valcheck)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520052,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c21520052.eqtg)
	e4:SetOperation(c21520052.eqop)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c21520052.desreptg)
	e5:SetOperation(c21520052.desrepop)
	c:RegisterEffect(e5)
end
function c21520052.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler()==e:GetHandler()
end
function c21520052.spfilter(c)
	return c:GetEquipGroup():IsExists(Card.IsSetCard,5,nil,0x494) and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,21520046)
end
function c21520052.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c21520052.spfilter,tp,LOCATION_MZONE,0,nil)
	return g and g:GetCount()>0
end
function c21520052.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c21520052.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c21520052.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	local atk,def=0,0
	while tc do
		if tc:GetTextAttack()<0 then atk=atk+0 else atk=atk+tc:GetTextAttack() end
		if tc:GetTextDefense()<0 then def=def+0 else def=def+tc:GetTextDefense() end
		tc=g:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,atk)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,e:GetHandler(),1,0,def)
	Duel.SetChainLimit(aux.FALSE)
end
function c21520052.adop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	local atk,def=0,0
	while tc do
		if tc:GetTextAttack()<0 then atk=atk+0 else atk=atk+tc:GetTextAttack() end
		if tc:GetTextDefense()<0 then def=def+0 else def=def+tc:GetTextDefense() end
		tc=g:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(atk)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetValue(def)
	c:RegisterEffect(e3)
end
function c21520052.valcheck(e)
	Duel.SetChainLimit(aux.FALSE)
end
function c21520052.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown()
		or not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.Equip(tp,tc,c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c21520052.eqlimit)
	tc:RegisterEffect(e1)
	local atk=tc:GetTextAttack()
	if atk<0 then atk=0 end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(atk)
	tc:RegisterEffect(e2)
	local def=tc:GetTextDefense()
	if def<0 then def=0 end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetValue(def)
	tc:RegisterEffect(e3)
end
function c21520052.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c21520052.eqlimit(e,c)
	return e:GetOwner()==c
end
function c21520052.repfilter(c)
	return c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c21520052.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c21520052.repfilter,1,nil)
	end
	local g=c:GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:FilterSelect(tp,c21520052.repfilter,1,1,nil)
	Duel.SetTargetCard(sg)
	return true
end
function c21520052.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end
