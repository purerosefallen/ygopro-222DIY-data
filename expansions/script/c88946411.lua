--生死轮舞 虚化的安魂绘卷
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946411
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	e1:SetOperation(cm.regop)
	local e2=rsef.FTO(c,m,nil,{1,m},"se,th","de",LOCATION_FZONE)
	rsef.RegisterSolve(e2,cm.thcon,nil,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK+LOCATION_GRAVE)),cm.thop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(m)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
end
function cm.regop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	Duel.RaiseEvent(c,m,e,0,tp,tp,0)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0x8964) and (c:IsAbleToHand() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetActivateEffect():IsActivatable(tp)))
end
function cm.thop(e,tp)
	if not aux.ExceptThisCard(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local b1=tc:IsAbleToHand()
	local b2=tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:GetActivateEffect():IsActivatable(tp)
	local op=rsof.SelectOption(tp,b1,{m,0},b2,{m,1})
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end
