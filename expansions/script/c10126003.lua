--反骨的勇士 勇
function c10126003.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126003,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c10126003.otcon)
	e1:SetOperation(c10126003.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126003,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10126003.eqtg)
	e3:SetOperation(c10126003.eqop)
	c:RegisterEffect(e3)  
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10126003,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetCondition(c10126003.necon)
	e4:SetCost(c10126003.necost)
	e4:SetTarget(c10126003.netg)
	e4:SetOperation(c10126003.neop)
	c:RegisterEffect(e4)  
end
function c10126003.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1335) and not c:IsCode(10126003)
end
function c10126003.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126003.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_GRAVE+LOCATION_DECK)
end
function c10126003.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10126003.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c10126003.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or not Duel.Equip(tp,tc,c,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c10126004.eqlimit)
	tc:RegisterEffect(e1)
end
function c10126003.otfilter(c,tp)
	if c:IsHasEffect(EFFECT_CANNOT_RELEASE) or not Duel.IsPlayerCanRelease(tp,c) then return false end
	--if not c:IsReleasable() then return false end
	if c:IsLocation(LOCATION_SZONE) then return c:GetEquipTarget() and c:GetEquipTarget():IsControler(tp)
	else return c:IsSetCard(0x1335)
	end
end
function c10126003.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10126003.otfilter,tp,LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE,1,c,tp)
end
function c10126003.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c10126003.otfilter,tp,LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE,1,1,c,tp)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c10126003.necon(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c10126003.cfilter(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(tp) 
end
function c10126003.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126003.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,2,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c10126003.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,2,2,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c10126003.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10126003.neop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=re:GetHandler(),e:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(re) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10126003,3)) and Duel.Equip(1-tp,tc,c,false) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	   e1:SetCode(EFFECT_EQUIP_LIMIT)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetValue(c10126003.eqlimit)
	   tc:RegisterEffect(e1)
	end
end