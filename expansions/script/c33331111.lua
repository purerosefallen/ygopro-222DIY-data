--小狐的惊喜
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331111
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=rsef.FTO(c,EVENT_TO_GRAVE,{m,0},nil,"td,dr","de",LOCATION_GRAVE,cm.tdcon,rscost.cost(Card.IsAbleToRemoveAsCost,"rm"),rstg.target2(cm.fun,rsop.list(Card.IsAbleToDeck,"td",LOCATION_GRAVE+LOCATION_REMOVED,0,1,true,c)),cm.tdop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_REMOVE)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler())
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.tdcon(e,tp,eg)
	local f=function(c)
		return c:IsSetCard(0x2553) and c:IsType(TYPE_MONSTER) and (not c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
	end
	return eg:IsExists(f,1,nil)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2553) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetLabelObject(tc)
		e2:SetValue(cm.aclimit)
		e2:SetCondition(cm.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetLabelObject()
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
