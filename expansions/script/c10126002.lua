--反骨的斗士 勇
function c10126002.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126002,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c10126002.otcon)
	e1:SetOperation(c10126002.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--Equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126002,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10126002.eqtg)
	e3:SetOperation(c10126002.eqop)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10126002,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c10126002.descost)
	e4:SetTarget(c10126002.destg)
	e4:SetOperation(c10126002.desop)
	c:RegisterEffect(e4)	
end
function c10126002.eqfilter(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c10126002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10126002.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_GRAVE+LOCATION_HAND)
end
function c10126002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10126002.eqfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,c):GetFirst()
	if tc then
	   Duel.Equip(tp,tc,c,true)
	end
end
function c10126002.otfilter(c,tp)
	if c:IsHasEffect(EFFECT_CANNOT_RELEASE) or not Duel.IsPlayerCanRelease(tp,c) then return false end
	--if not c:IsReleasable() then return false end
	if c:IsLocation(LOCATION_SZONE) then return c:GetEquipTarget() and c:GetEquipTarget():IsControler(tp)
	else return c:IsSetCard(0x1335)
	end
end
function c10126002.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10126002.otfilter,tp,LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE,1,c,tp)
end
function c10126002.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c10126002.otfilter,tp,LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE,1,1,c,tp)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c10126002.desfilter1(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(tp)  and ec:IsReleasable() and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,c)
end
function c10126002.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126002.desfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c10126002.desfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c10126002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10126002.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED) and bit.band(tc:GetOriginalType(),TYPE_MONSTER)~=0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsRelateToEffect(e) and c:IsFaceup() and not tc:IsLocation(LOCATION_DECK) and Duel.SelectYesNo(tp,aux.Stringid(10126002,3)) then
		Duel.BreakEffect()
		if Duel.Equip(1-tp,tc,c,true) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		   e1:SetCode(EFFECT_EQUIP_LIMIT)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   e1:SetValue(c10126002.eqlimit)
		   tc:RegisterEffect(e1)
		end
	end
end
function c10126002.eqlimit(e,c)
	return e:GetOwner()==c
end