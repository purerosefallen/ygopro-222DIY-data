--「你们太强了我打不过」
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010009
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	e1:SetCondition(cm.con)
	local e2=rsef.QO(c,nil,{m,1},{1,m},"eq",{"tg",EFFECT_FLAG_NO_TURN_RESET },LOCATION_SZONE,nil,nil,rstg.target({rscf.FilterFaceUp(Card.IsCode,65010001),"eq",LOCATION_MZONE }),cm.op)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and e:GetHandler():GetEquipTarget()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function cm.con(e,tp)
	local f=function(c)
		return c:IsFacedown() or not c:IsType(TYPE_NORMAL)
	end
	return not Duel.IsExistingMatchingCard(f,tp,LOCATION_MZONE,0,1,nil)
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard()
	if rsop.eqop(e,c,tc) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetReset(rsreset.est)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetValue(aux.tgoval)
		c:RegisterEffect(e2)
	end
end
