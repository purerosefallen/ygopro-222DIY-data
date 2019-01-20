--「02的威压」
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010004
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_SZONE,nil,rscost.cost({aux.FilterBoolFunction(Card.IsCode,65010001),"res",LOCATION_MZONE }),nil,cm.op)
	local f=function(rc)
		return aux.IsCodeListed(rc,65010001)
	end
	local e3=rsef.QO(c,nil,{m,1},{1,m+100},"atk,dis","tg",LOCATION_SZONE,nil,rscost.cost({f,"td",LOCATION_GRAVE }),cm.tg2,cm.op2)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 or chkc then return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,{Card.IsFaceup,"atk",LOCATION_MZONE,LOCATION_MZONE }) end
	rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,{Card.IsFaceup,"atk",LOCATION_MZONE,LOCATION_MZONE })
	if rscon.excard(rscf.FilterFaceUp(Card.IsCode,65010001))(e) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.op2(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local tc=rscf.GetTargetCard()
	if tc then
		local atk=tc:GetAttack()
		local e1=rsef.SV_SET({c,tc},"atkf",atk/2,nil,rsreset.est_pend)
	end
	if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(cm.distg)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabel(tc:GetOriginalCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local e1=rsef.FV_INDESTRUCTABLE({c,tp},"effect",1,aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP),{LOCATION_ONFIELD,0},nil,rsreset.pend)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetReset(rsreset.pend)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.disop)
	Duel.RegisterEffect(e2,tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local f=function(c,p)
		return c:IsControler(p) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	end
	return g and g:IsExists(f,1,nil,tp) and rp~=tp and Duel.IsChainDisablable(ev)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
