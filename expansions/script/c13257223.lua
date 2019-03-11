--宇宙战争兵器 主炮 495年的折反镭射
function c13257223.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257223.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257223.econ)
	e12:SetValue(c13257223.efilter)
	c:RegisterEffect(e12)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257223,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DICE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c13257223.codisable)
	e3:SetTarget(c13257223.tgdisable)
	e3:SetOperation(c13257223.opdisable)
	c:RegisterEffect(e3)
	c:RegisterFlagEffect(13257201,0,0,0,5)
	
end
function c13257223.eqlimit(e,c)
	local eg=c:GetEquipGroup()
	local lv=c:GetOriginalLevel()
	if lv==nil then lv=0 end
	if not eg:IsContains(e:GetHandler()) then
		eg:AddCard(e:GetHandler())
	end
	local cl=c:GetFlagEffectLabel(13257200)
	if cl==nil then
		cl=0
	end
	local er=e:GetHandler():GetFlagEffectLabel(13257201)
	if er==nil then
		er=0
	end
	return not (er>cl) and not (eg:Filter(Card.IsSetCard,nil,0x354):GetSum(Card.GetLevel)>lv) and not c:GetEquipGroup():IsExists(Card.IsCode,1,e:GetHandler(),e:GetHandler():GetCode())
end
function c13257223.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257223.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257223.codisable(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c13257223.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c13257223.opdisable(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local cl=c:GetEquipTarget():GetFlagEffectLabel(13257200)
	if cl==nil then
		cl=0
	end
	local d=Duel.TossDice(tp,1)+1
	if cl<d and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Damage(1-tp,cl*cl*40,REASON_EFFECT)
	end
end
