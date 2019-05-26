--新干线先锋 E5隼
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008006
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssk.LinkFun(c)   
	local e2=rsef.QO(c,nil,{m,0},{1,m},"se,th",nil,LOCATION_MZONE,nil,rssk.rmcost,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e3=rsef.FTO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+100},"th","de,dsp",LOCATION_MZONE,rssk.lfcon,nil,rstg.target(rsop.list(Card.IsAbleToHand,"th",0,LOCATION_ONFIELD)),cm.thop3)
	local e4=rsef.FV_CANNOT_BE_TARGET(c,"effect",aux.tgoval,table.unpack(rssk.link()))  
end
cm.rssetcode="Shinkansen"
function cm.thfilter(c)
	return c:IsAbleToHand() and rssk.set(c)
end
function cm.thop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1)
	e1:SetCondition(cm.thcon2)
	e1:SetOperation(cm.thop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.thop3(e,tp,eg,ep,ev,re,r,rp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end