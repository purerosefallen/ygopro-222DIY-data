--吸血姬·龙姬
function c9980274.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9980274.ffilter,3,true)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c9980274.splimit)
	c:RegisterEffect(e2)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9980274.sprcon)
	e2:SetOperation(c9980274.sprop)
	c:RegisterEffect(e2)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980274,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c9980274.eqcon1)
	e1:SetTarget(c9980274.eqtg)
	e1:SetOperation(c9980274.eqop)
	c:RegisterEffect(e1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980274,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9980274.eqcon2)
	e1:SetTarget(c9980274.eqtg)
	e1:SetOperation(c9980274.eqop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9980274.atkval)
	c:RegisterEffect(e2)
	--def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c9980274.defval)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c9980274.distg)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c9980274.discon)
	e6:SetOperation(c9980274.disop)
	c:RegisterEffect(e6)
	--atk limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c9980274.distg)
	c:RegisterEffect(e5)
end
function c9980274.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c9980274.ffilter(c)
	return c:IsFusionType(TYPE_MONSTER) and c:IsFusionSetCard(0xbc2)and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c9980274.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9980274.sprfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp,c)
end
function c9980274.sprfilter1(c,tp,fc)
	return c:IsFusionSetCard(0xbc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c9980274.sprfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,fc,c)
end
function c9980274.sprfilter2(c,tp,fc,mc)
	return c:IsFusionSetCard(0xbc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionCode(mc:GetFusionCode())
		and Duel.IsExistingMatchingCard(c9980274.sprfilter3,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,fc,mc,c)
end
function c9980274.sprfilter3(c,tp,fc,mc1,mc2)
	local g=Group.FromCards(c,mc1,mc2)
	return c:IsFusionSetCard(0xbc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionCode(mc1:GetFusionCode()) and not c:IsFusionCode(mc2:GetFusionCode())
		and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c9980274.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c9980274.sprfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c9980274.sprfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c9980274.sprfilter3,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst(),g2:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c9980274.can_equip_monster(c)
	return true
end
function c9980274.eqcon1(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c9980274.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c9980274.can_equip_monster(c)
end
function c9980274.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler()
end
function c9980274.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c9980274.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9980274.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9980274.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c9980274.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9980274.equip_monster(c,tp,tc)
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(9980274,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c9980274.eqlimit)
	tc:RegisterEffect(e1)
end
function c9980274.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c9980274.equip_monster(c,tp,tc)
		else Duel.SendtoGrave(tc,REASON_RULE) end
	end
end
function c9980274.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(9980274)~=0 and tc:IsFaceup() and tc:GetAttack()>=0 then
			atk=atk+tc:GetAttack()
		end
		tc=g:GetNext()
	end
	return atk
end
function c9980274.defval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(9980274)~=0 and tc:IsFaceup() and tc:GetDefense()>=0 then
			atk=atk+tc:GetDefense()
		end
		tc=g:GetNext()
	end
	return atk
end
function c9980274.disfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(9980274)~=0
end
function c9980274.distg(e,c)
	if c:IsFacedown() then return false end
	local g=e:GetHandler():GetEquipGroup():Filter(c9980274.disfilter,nil)
	local code=c:GetCode()
	local code2=c:GetFlagEffectLabel(41578484)
	if code2 then code=code2 end
	local res=g:IsExists(Card.IsCode,1,nil,code)
	if res and code2==nil and code~=c:GetOriginalCode() then
		c:RegisterFlagEffect(41578484,RESET_EVENT+RESETS_STANDARD,0,0,code)
	end
	return res
end
function c9980274.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c9980274.disfilter,nil)
	return re:IsActiveType(TYPE_MONSTER) and g:IsExists(Card.IsCode,1,nil,re:GetHandler():GetCode())
end
function c9980274.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
