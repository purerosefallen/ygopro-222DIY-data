--生死轮舞 洛卡希斯·绚散
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946404
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_PZONE,rscon.phmp,nil,cm.tg,cm.op)
	local e2,e7=rslrd.RitualFunction(c,m)
	local e3=rslrd.SummonLimitFunction(c)
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"th","tg,de",nil,nil,rstg.target({Card.IsAbleToHand,"th",LOCATION_ONFIELD },{Card.IsAbleToHand,"th",0,LOCATION_ONFIELD }),cm.thop)
	local e5=rsef.QO(c,nil,{m,1},{1,m+100},"th","tg",LOCATION_HAND,nil,rslrd.dishcost,rstg.target({Card.IsAbleToHand,"th",LOCATION_ONFIELD },{Card.IsAbleToHand,"th",0,LOCATION_ONFIELD }),cm.thop)
	local e6=rslrd.RemoveFunction(c)
	cm.pendlumeffect={e1,e2}
	cm.monstereffect={e5,e6}
end
function cm.thop(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function cm.cfilter2(c,code)
	return not c:IsCode(code) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),e:GetHandler():GetOriginalCode()) end
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,c:GetOriginalCode())
	if #tg<=0 then return end
	local tc=tg:GetFirst()
	if tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc)
	else Duel.HintSelection(tg)
	end
	local e1=rsef.SV_ADD({c,tc},"code",c:GetOriginalCode(),nil,rsreset.est_pend-RESET_TOFIELD)
	local e2=rsef.SV_ADD({c,tc},"type",TYPE_TUNER,nil,rsreset.est_pend-RESET_TOFIELD)
end